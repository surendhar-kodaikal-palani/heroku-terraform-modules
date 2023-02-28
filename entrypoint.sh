#!/bin/bash


# Define variables for Terragrunt commands
terragrunt_cmd= "terragrunt"
terragrunt_args="plan"

# Ask user for Terragrunt command to run
read -p "Enter Terragrunt command to run (default: plan): " cmd_input
if [ ! -z "$cmd_input" ]; then
  terragrunt_args="$cmd_input"
fi

# Ask user for Terragrunt configuration directory
read -p "Enter Terragrunt configuration directory (default: .): " dir_input
if [ ! -z "$dir_input" ]; then
  terragrunt_cmd="$terragrunt_cmd --terragrunt-working-dir $dir_input"
fi

# Ask user for Terragrunt options
read -p "Enter additional Terragrunt options (press enter to skip): " opt_input
if [ ! -z "$opt_input" ]; then
  terragrunt_cmd="$terragrunt_cmd $opt_input"
fi

# Display Terragrunt command to be executed
echo "Terragrunt command to run: $terragrunt_cmd $terragrunt_args"

# Confirm if user wants to run Terragrunt command
read -p "Do you want to run this Terragrunt command? (y/n) " confirm
if [[ $confirm =~ ^[Yy]$ ]]; then
  # Execute Terragrunt command
  $terragrunt_cmd $terragrunt_args
fi