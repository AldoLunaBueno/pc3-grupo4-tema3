#!/usr/bin/env bash


# Configuración y Comprobaciones Previas
CONFIG_FILE="build_config.yaml"
TERRAFORM_CMD="terraform"
AUTO_APPROVE_FLAG=""

log_error() {
    echo "[BUILD_SCRIPT_ERROR] $1"
}

log_info() {
    echo "[BUILD_SCRIPT_INFO] $1"
}

if [[ ! -f "$CONFIG_FILE" ]]; then
    log_error "El archivo de configuración '$CONFIG_FILE' no fue encontrado en ($(pwd))."
    exit 1
fi

log_info "Iniciando Proceso de Construcción con Terraform ..."

global_settings_block=$(awk '/^global_settings:/{flag=1; next} /^[^[:space:]]/{flag=0} flag' "$CONFIG_FILE")

if [[ -n "$global_settings_block" ]]; then
    TF_CMD_FROM_CONFIG=$(echo "$global_settings_block" | grep 'terraform_command:' | sed -e 's/^[[:space:]]*terraform_command:[[:space:]]*//' -e 's/"//g' -e "s/'//g" -e 's/[[:space:]]*#.*$//')
    if [[ -n "$TF_CMD_FROM_CONFIG" ]]; then
        TERRAFORM_CMD="$TF_CMD_FROM_CONFIG"
    fi

    AUTO_APPROVE_FROM_CONFIG=$(echo "$global_settings_block" | grep 'auto_approve:' | sed 's/^[[:space:]]*auto_approve:[[:space:]]*//' | sed 's/[[:space:]]*#.*$//')
    if [[ "$AUTO_APPROVE_FROM_CONFIG" == "true" ]]; then
        AUTO_APPROVE_FLAG="-auto-approve"
    fi
fi


#Procesar Pasos de Construcción
build_steps_content=$(awk '/^build_steps:/{flag=1; next} /^[^[:space:]]/{flag=0} flag' "$CONFIG_FILE")
num_steps=$(echo "$build_steps_content" | grep -c "^  - name:")

if [[ "$num_steps" -eq 0 ]]; then
    log_info "No se encontraron pasos de construcción ('build_steps') en '$CONFIG_FILE'."
    exit 0
fi

log_info "Se ejecutarán $num_steps pasos."

current_step_lines=""
step_counter=0
OLD_IFS="$IFS"
IFS=$'\n'

echo "$build_steps_content" | while IFS= read -r line || [[ -n "$line" ]]; do
    if [[ "$line" =~ ^[[:space:]]*-[[:space:]]+name: ]]; then
        if [[ -n "$current_step_lines" ]]; then
            ((step_counter++))
            step_name=$(echo "$current_step_lines" | grep 'name:' | sed -E 's/^[[:space:]]*-?[[:space:]]*name:[[:space:]]*"?([^"]*)"?/\1/' | sed 's/[[:space:]]*#.*$//')
            step_directory=$(echo "$current_step_lines" | grep 'directory:' | sed -E 's/^[[:space:]]*directory:[[:space:]]*"?([^"]*)"?/\1/' | sed 's/[[:space:]]*#.*$//')
            step_action=$(echo "$current_step_lines" | grep 'action:' | sed -E 's/^[[:space:]]*action:[[:space:]]*"?([^"]*)"?/\1/' | sed 's/[[:space:]]*#.*$//')
            [[ -z "$step_action" ]] && step_action="apply"

            echo 
            log_info "--- Paso $step_counter/$num_steps: $step_name ---"

            if [[ ! -d "$step_directory" ]]; then
                log_error "Directorio '$step_directory' para '$step_name' no existe. Omitiendo."
                current_step_lines="$line"
                continue
            fi

            pushd "$step_directory" > /dev/null || { log_error "Error al cambiar a $step_directory"; current_step_lines="$line"; continue; }

            # log_info "  Ejecutando: $TERRAFORM_CMD init -input=false -no-color -upgrade" # Comentado
            if ! $TERRAFORM_CMD init -input=false -no-color -upgrade > /dev/null 2>&1; then # Silenciado init
                # Intenta de nuevo con salida si falla silenciosamente
                if ! $TERRAFORM_CMD init -input=false -no-color -upgrade; then
                    log_error "Terraform init falló para '$step_name'."
                    popd > /dev/null
                    current_step_lines="$line"
                    continue
                fi
            fi

            tf_command_vars_args=""
            variables_block=$(echo "$current_step_lines" | awk '/^[[:space:]]*variables:/{p=1;next} /^[[:space:]]*[^[:space:]]/{p=0} p')
            if [[ -n "$variables_block" ]]; then
                var_key=""
                var_value_json=""
                map_key=""
                map_json_content=""

                echo "$variables_block" | while IFS= read -r var_line || [[ -n "$var_line" ]]; do
                    var_line_no_comment=$(echo "$var_line" | sed 's/[[:space:]]*#.*$//')
                    clean_var_line=$(echo "$var_line_no_comment" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

                    if [[ -z "$clean_var_line" ]]; then continue; fi

                    if [[ "$clean_var_line" =~ ^([a-zA-Z0-9_]+):[[:space:]]*(.*)$ ]]; then
                        if [[ -n "$map_key" ]]; then
                             if [[ -n "$map_json_content" ]]; then map_json_content=${map_json_content%,}; fi
                            tf_command_vars_args+=" -var=\"$map_key={$map_json_content}\""
                            map_key=""; map_json_content=""
                        fi
                        current_var_key="${BASH_REMATCH[1]}"; current_var_value="${BASH_REMATCH[2]}"
                        if [[ -z "$current_var_value" ]]; then
                            map_key="$current_var_key"; map_json_content=""
                        else
                            current_var_value_no_quotes=$(echo "$current_var_value" | sed -e "s/^'//" -e "s/'$//" -e 's/^"//' -e 's/"$//')
                            if [[ "$current_var_value_no_quotes" == "true" || "$current_var_value_no_quotes" == "false" || "$current_var_value_no_quotes" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
                                var_value_json="$current_var_value_no_quotes"
                            else
                                var_value_json="\"$current_var_value_no_quotes\""
                            fi
                            tf_command_vars_args+=" -var=\"$current_var_key=$var_value_json\""
                        fi
                    elif [[ -n "$map_key" && "$clean_var_line" =~ ^([a-zA-Z0-9_]+):[[:space:]]*(.*)$ ]]; then
                        sub_key="${BASH_REMATCH[1]}"; sub_value="${BASH_REMATCH[2]}"
                        sub_value_no_quotes=$(echo "$sub_value" | sed -e "s/^'//" -e "s/'$//" -e 's/^"//' -e 's/"$//')
                        if [[ "$sub_value_no_quotes" == "true" || "$sub_value_no_quotes" == "false" || "$sub_value_no_quotes" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
                            map_json_content+="\"$sub_key\":$sub_value_no_quotes,"
                        else
                            map_json_content+="\"$sub_key\":\"$sub_value_no_quotes\","
                        fi
                    fi
                done
                if [[ -n "$map_key" ]]; then
                    if [[ -n "$map_json_content" ]]; then map_json_content=${map_json_content%,}; fi
                    tf_command_vars_args+=" -var=\"$map_key={$map_json_content}\""
                fi
            
            fi

            final_tf_command="$TERRAFORM_CMD $step_action -input=false $AUTO_APPROVE_FLAG $tf_command_vars_args"
            if ! $TERRAFORM_CMD $step_action -input=false $AUTO_APPROVE_FLAG $tf_command_vars_args; then
                log_error "El comando de Terraform falló para '$step_name'."
                popd > /dev/null
                current_step_lines="$line"
                continue
            fi
            popd > /dev/null
        fi
        current_step_lines="$line"
    elif [[ -n "$current_step_lines" ]]; then
        current_step_lines+=$'\n'"$line"
    fi
done

# Procesar el último paso si quedó alguno acumulado
if [[ -n "$current_step_lines" ]]; then
    ((step_counter++))
    step_name=$(echo "$current_step_lines" | grep 'name:' | sed -E 's/^[[:space:]]*-?[[:space:]]*name:[[:space:]]*"?([^"]*)"?/\1/' | sed 's/[[:space:]]*#.*$//')
    step_directory=$(echo "$current_step_lines" | grep 'directory:' | sed -E 's/^[[:space:]]*directory:[[:space:]]*"?([^"]*)"?/\1/' | sed 's/[[:space:]]*#.*$//')
    step_action=$(echo "$current_step_lines" | grep 'action:' | sed -E 's/^[[:space:]]*action:[[:space:]]*"?([^"]*)"?/\1/' | sed 's/[[:space:]]*#.*$//')
    [[ -z "$step_action" ]] && step_action="apply"


    echo
    log_info "Paso $step_counter/$num_steps: $step_name"


    if [[ ! -d "$step_directory" ]]; then
        log_error "Directorio '$step_directory' para '$step_name' no existe. Omitiendo."
    else
        pushd "$step_directory" > /dev/null || { log_error "Error al cambiar a $step_directory"; exit 1; }

        # log_info "  Ejecutando: $TERRAFORM_CMD init -input=false -no-color -upgrade" 
        if ! $TERRAFORM_CMD init -input=false -no-color -upgrade > /dev/null 2>&1; then # Silenciado init
            if ! $TERRAFORM_CMD init -input=false -no-color -upgrade; then
                log_error "Terraform init falló para '$step_name'."
                popd > /dev/null
            fi
        fi

        if [[ $? -eq 0 ]]; then # Continuar solo si init tuvo éxito (o no falló visiblemente)
            tf_command_vars_args=""
            variables_block=$(echo "$current_step_lines" | awk '/^[[:space:]]*variables:/{p=1;next} /^[[:space:]]*[^[:space:]]/{p=0} p')
             if [[ -n "$variables_block" ]]; then
                # log_info "  Variables para este paso:"
                var_key=""
                var_value_json=""
                map_key=""
                map_json_content=""
                echo "$variables_block" | while IFS= read -r var_line || [[ -n "$var_line" ]]; do
                    var_line_no_comment=$(echo "$var_line" | sed 's/[[:space:]]*#.*$//')
                    clean_var_line=$(echo "$var_line_no_comment" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

                    if [[ -z "$clean_var_line" ]]; then continue; fi

                    if [[ "$clean_var_line" =~ ^([a-zA-Z0-9_]+):[[:space:]]*(.*)$ ]]; then
                        if [[ -n "$map_key" ]]; then
                             if [[ -n "$map_json_content" ]]; then map_json_content=${map_json_content%,}; fi
                            tf_command_vars_args+=" -var=\"$map_key={$map_json_content}\""
                            # log_info "    - $map_key = {$map_json_content}" 
                            map_key=""; map_json_content=""
                        fi
                        current_var_key="${BASH_REMATCH[1]}"; current_var_value="${BASH_REMATCH[2]}"
                        if [[ -z "$current_var_value" ]]; then
                            map_key="$current_var_key"; map_json_content=""
                        else
                            current_var_value_no_quotes=$(echo "$current_var_value" | sed -e "s/^'//" -e "s/'$//" -e 's/^"//' -e 's/"$//')
                            if [[ "$current_var_value_no_quotes" == "true" || "$current_var_value_no_quotes" == "false" || "$current_var_value_no_quotes" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
                                var_value_json="$current_var_value_no_quotes"
                            else
                                var_value_json="\"$current_var_value_no_quotes\""
                            fi
                            tf_command_vars_args+=" -var=\"$current_var_key=$var_value_json\""
                            # log_info "    - $current_var_key = $var_value_json" 
                        fi
                    elif [[ -n "$map_key" && "$clean_var_line" =~ ^([a-zA-Z0-9_]+):[[:space:]]*(.*)$ ]]; then
                        sub_key="${BASH_REMATCH[1]}"; sub_value="${BASH_REMATCH[2]}"
                        sub_value_no_quotes=$(echo "$sub_value" | sed -e "s/^'//" -e "s/'$//" -e 's/^"//' -e 's/"$//')
                        if [[ "$sub_value_no_quotes" == "true" || "$sub_value_no_quotes" == "false" || "$sub_value_no_quotes" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
                            map_json_content+="\"$sub_key\":$sub_value_no_quotes,"
                        else
                            map_json_content+="\"$sub_key\":\"$sub_value_no_quotes\","
                        fi
                    fi
                done
                if [[ -n "$map_key" ]]; then
                    if [[ -n "$map_json_content" ]]; then map_json_content=${map_json_content%,}; fi
                    tf_command_vars_args+=" -var=\"$map_key={$map_json_content}\""
                    # log_info "    - $map_key = {$map_json_content}" 
                fi
            # else
                # log_info "  Sin variables adicionales para este paso." 
            fi

            final_tf_command="$TERRAFORM_CMD $step_action -input=false $AUTO_APPROVE_FLAG $tf_command_vars_args"
            log_info "  Ejecutando para '$step_name': $TERRAFORM_CMD $step_action $AUTO_APPROVE_FLAG ..."
            if ! $TERRAFORM_CMD $step_action -input=false $AUTO_APPROVE_FLAG $tf_command_vars_args; then
                log_error "El comando de Terraform falló para '$step_name'."
            else
                log_info "  Paso '$step_name' completado."
            fi
            echo "Fin de Salida de Terraform"
            popd > /dev/null
        fi 
    fi
fi

IFS="$OLD_IFS"

echo
log_info "Fin del Proceso de Construcción con Terraform"
exit 0