#!/bin/bash

# Reseting the environment
rm -rf "${HOME}/.lowbit-cash"

# Creating accounts
./cash.sh account add --name Conta-Corrente --group C6Bank --type bank --initial-balance 10000.00
./cash.sh account list

# Creating envelopes
./cash.sh envelope add --name Livre --group Lazer --type expense --budget 2000.00

# Starting reconciliation
./cash.sh account reconcile --account C6Bank:Conta-Corrente --balance 9900.00

# Adding transactions until close reconciliation
./cash.sh transaction add-expense --account C6Bank:Conta-Corrente --envelope Lazer:Livre --amount 50.00 --date 2025-12-10 --description "Presente para o pai"
./cash.sh transaction add-expense --account C6Bank:Conta-Corrente --envelope Lazer:Livre --amount 50.00 --date 2025-12-11 --description "Presente para a mãe"

# Result
./cash.sh account list