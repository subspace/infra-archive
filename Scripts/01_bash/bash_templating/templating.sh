#!/bin/bash

function create_odd_even_key_value_array() {
  ARR=("$@")
  RESULT=()
  for (( i = 0; i < ${#ARR[@]}; i++ )); do
    item=${ARR[$i]}
    itemNext=${ARR[$i+1]}
    if [[ $item = --* ]]
    then
      RESULT+=("$item")
      if [ -z "$itemNext" ]
      then
        RESULT+=(null)
      else
        if [[ $itemNext = --* ]]
        then
          RESULT+=(null)
        else
          RESULT+=($itemNext)
        fi
      fi
    fi
  done

  echo "${RESULT[@]}"
}

# read params
USER_COMMANDS=()
USER_COMMAND_PARAMS_TO_REMOVE=()

for i in "$@"; do
  case $i in
    -i=*|--image=*)
      USER_IMAGE="${i#*=}"
      shift # past argument=value
      ;;
    -cp=*|--command-param=*)
      USER_COMMANDS+=('--'"${i#*=}")
      shift # past argument=value
      ;;
    -cv=*|--command-value=*)
      USER_COMMANDS+=("${i#*=}")
      shift # past argument=value
      ;;
    -cpr=*|--command-param-to-remove=*)
      USER_COMMAND_PARAMS_TO_REMOVE+=('--'"${i#*=}")
      shift # past argument=value
      ;;
    -*|--*)
      echo "Unknown option $i"
      exit 1
      ;;
    *)
      ;;
  esac
done


while IFS= read -r value; do
    ORIGINAL_COMMANDS+=($value)
done < <(yq eval '.services.node.command[]' "docker-compose.yml")

echo "----- CREATING MAPS -----"
ORIGINAL_KEY_VALUE_ARRAY=($(create_odd_even_key_value_array "${ORIGINAL_COMMANDS[@]}"))
# shellcheck disable=SC2145
echo "ORIGINAL_KEY_VALUE_ARRAY: ${ORIGINAL_KEY_VALUE_ARRAY[@]}"

USER_KEY_VALUE_ARRAY=($(create_odd_even_key_value_array "${USER_COMMANDS[@]}"))
# shellcheck disable=SC2145
echo "USER_KEY_VALUE_ARRAY: ${USER_KEY_VALUE_ARRAY[@]}"
# shellcheck disable=SC2145
echo "USER COMMAND PARAMS TO REMOVE: ${USER_COMMAND_PARAMS_TO_REMOVE[@]}"

echo "----- PREPARING COMMANDS -----"
# Remove commands
COMMANDS_AFTER_REMOVING=()
for (( i = 0; i < ${#ORIGINAL_KEY_VALUE_ARRAY[@]}; i=i+2 )); do
  key=${ORIGINAL_KEY_VALUE_ARRAY[$i]};
  value=${ORIGINAL_KEY_VALUE_ARRAY[$i+1]};
  if [[ ! " ${USER_COMMAND_PARAMS_TO_REMOVE[*]} " == *" ${key} "* ]]
  then
      COMMANDS_AFTER_REMOVING+=($key)
      COMMANDS_AFTER_REMOVING+=($value)
  fi
done
# shellcheck disable=SC2145
echo "COMMANDS_AFTER_REMOVING: ${COMMANDS_AFTER_REMOVING[@]}"

# Update commands
UPDATED_COMMANDS=()
for (( i = 0; i < ${#COMMANDS_AFTER_REMOVING[@]}; i=i+2 )); do
  key=${COMMANDS_AFTER_REMOVING[$i]};
  value=${COMMANDS_AFTER_REMOVING[$i+1]};

  for (( i2 = 0; i2 < ${#USER_KEY_VALUE_ARRAY[@]}; i2=i2+2 )); do
    if [[ "${USER_KEY_VALUE_ARRAY[$i2]}" = "${key}" ]]; then
        value=${USER_KEY_VALUE_ARRAY[$i2+1]};
    fi
  done

  UPDATED_COMMANDS+=($key)
  UPDATED_COMMANDS+=($value)
done
# shellcheck disable=SC2145
echo "UPDATED_COMMANDS: ${UPDATED_COMMANDS[@]}"

# Remove null values
NEW_COMMANDS=()
for (( i = 0; i < ${#UPDATED_COMMANDS[@]}; i=i+2 )); do
  key=${UPDATED_COMMANDS[$i]};
  value=${UPDATED_COMMANDS[$i+1]};

  NEW_COMMANDS+=($key)
  if [[ ! "${value}" = null ]]; then
    NEW_COMMANDS+=($value)
  fi
done
# shellcheck disable=SC2145
echo "NEW_COMMANDS: ${NEW_COMMANDS[@]}"

## ---- EXECUTING UPDATES ----
# UPDATE image
if [ -n "${USER_IMAGE}" ]
then
  yq -i ".services.node.image = \"${USER_IMAGE}\"" docker-compose.yml
fi
# UPDATE commands
TMP_COMMAND_FOR_SAVING_ARRAY_FORMAT="67b93e37-5e39-4e6a-8e65-a15232328202"
yq -i ".services.node.command += \"${TMP_COMMAND_FOR_SAVING_ARRAY_FORMAT}\"" docker-compose.yml
yq -i "del( .services.node.command[] | select(. != \"${TMP_COMMAND_FOR_SAVING_ARRAY_FORMAT}\") )" docker-compose.yml
for (( i = 0; i < ${#NEW_COMMANDS[@]}; i++ )); do
  item=${NEW_COMMANDS[$i]};
  yq -i ".services.node.command += \"${item}\"" docker-compose.yml
done
yq -i "del( .services.node.command[] | select(. == \"${TMP_COMMAND_FOR_SAVING_ARRAY_FORMAT}\") )" docker-compose.yml