# Lowbit Cash

## About

**Lowbit Cash** is part of the *Lowbit Suite*, and is a *CLI Tool* to manage your finances without leaving the terminal.

## Installation

To install the last stable version in your computer, simply git-clone the repository wherever you prefer. For example:

```bash
$ cd Documents
$ git clone git@github.com:lowbit-inc/lowbit-cash.git
$ cd lowbit-cash
$ ./cash.sh version
```

> A dedicated `install` subcommand is planned to be implemented later.

## Dependencies

Lowbit Cash requires `sqlite3` to work, acting as it's main storage.

## Initializing the Database

The CLI database is automatically initialized when you run the CLI and a database is not found in the expectec path (`${HOME}/.lowbit-cash/cash.db`). For example:

```bash
$ ./cash.sh balance

# Output:
# [2025-12-15 09:44:27] [info ] Database file not found. Initializing at /Users/lowbit/.lowbit-cash/cash.db...
# Total balance: 0.0
```

## Main Features

All of the *core* functionalities of the CLI can be grouped in the following features:

### Accounts

This is generally where you begin using the tool. Create account to represent **where your money really is**.

Also, you can check your total balance, for all your accounts.

### Envelopes

This is virtual representations of your money. Based on the *envelope budget* method, but digital. Create envelopes to represent **where your money is virtually**.

The sum of your envelopes will **always** be equal to the sum of your account balances, functioning as a **persistent** and more powerful budget.

### Transactions

This is what you expect: transactions, representing the movements your money do. A transaction can be an **income**, an **expense**, or **transfers** between accounts and envelopes.

### Reports

This is where you go to analyse your finance data after using the CLI for a while. Unfortunately, at this moment, no reports are implemented. But some of them are planned for the first release (`v1.0.0`).

## Getting Started

Follow this quick guide to understand the basics of the tool. To go further, simply use the CLI as you want, because I tried to create natural usage messages for all the commands and subcommands.

### Creating your first accounts

```bash
$ ./cash.sh account add --name "Checking" --group "BankA" --type bank --initial-balance 1000.00

# Output:
# [2025-12-15 20:49:55] [info ] Added account BankA:Checking
# [2025-12-15 20:49:55] [info ] Added Opening Balance transaction for account BankA:Checking

$ ./cash.sh account add --name "MasterCard" --group "BankA" --type creditcard --initial-balance -100.00

# Output:
# [2025-12-15 20:52:12] [info ] Added account BankA:MasterCard
# [2025-12-15 20:52:12] [info ] Added Opening Balance transaction for account BankA:MasterCard
```

### Checking your balance

```bash
$ ./cash.sh account list

# Output:
# ┌────┬───────┬────────────┬────────────┬─────────┬─────────────┬─────────────────┬────────────────────┐
# │ ID │ Group │    Name    │    Type    │ Balance │ Reconciled? │ Reconciled Date │ Reconciled Balance │
# ├────┼───────┼────────────┼────────────┼─────────┼─────────────┼─────────────────┼────────────────────┤
# │ 1  │ BankA │ Checking   │ bank       │ 1000.0  │ False       │                 │                    │
# │ 2  │ BankA │ MasterCard │ creditcard │ -100.0  │ False       │                 │                    │
# └────┴───────┴────────────┴────────────┴─────────┴─────────────┴─────────────────┴────────────────────┘
# Total balance: 900.0
```

This is where your money is, and the total balance of the money you have.

If you only want to view your balance, try the shorter command:

```bash
$ ./cash.sh balance

# Output:
# Total balance: 900.0
```

> Notice that your total balance is **900.00**, because of the negative balance of your credit card.

### Creating your first envelopes

Envelopes act as a virtual representation of your money, and also as a budget tool (but with *steroids*).

Create one or more envelopes to represent the money you are expected to **earn**:

```bash
$ ./cash.sh envelope add --name Salary --group Work --type income --budget 1000.00

# Output:
# [2025-12-15 21:00:01] [info ] Added envelope Work:Salary
```

Create one or more envelopes to represent the money you are expected to **spend**:

```bash
$ ./cash.sh envelope add --name Home --group Bills --type expense --budget 500.00
# [2025-12-15 21:02:19] [info ] Added envelope Bills:Home

$ ./cash.sh envelope add --name Free --group Fun --type expense --budget 300.00
# [2025-12-15 21:02:49] [info ] Added envelope Fun:Free

$ ./cash.sh envelope add --name Savings --group Investment --type expense --budget 200.00
# [2025-12-15 21:03:17] [info ] Added envelope Investment:Savings
```

### Checking your envelopes and budget

Start by listing your envelopes:

```bash
./cash.sh envelope list

# Output:
# ┌────┬────────────┬─────────────┬─────────┬────────┬─────────┐
# │ ID │   Group    │    Name     │  Type   │ Budget │ Balance │
# ├────┼────────────┼─────────────┼─────────┼────────┼─────────┤
# │ 2  │ Work       │ Salary      │ income  │ 1000.0 │ 0.0     │
# │ 3  │ Bills      │ Home        │ expense │ 500.0  │ 0.0     │
# │ 4  │ Fun        │ Free        │ expense │ 300.0  │ 0.0     │
# │ 5  │ Investment │ Savings     │ expense │ 200.0  │ 0.0     │
# │ 1  │ Reserved   │ Unallocated │ --      │        │ 900.0   │
# └────┴────────────┴─────────────┴─────────┴────────┴─────────┘
# Total balance:    900.0
# Unallocated:      900.0

# Budgeted Income:  1000.0
# Budgeted Expense: 1000.0
# Difference:       0.0

```

Let's break down this output:
- First, you see a list of your envelopes, it's planned monthly budget, and it's current balance;
- The last envelope, called `Reserved:Unallocated` is a system-default and internal one (which cannot be deleted or edited) and is used to represent the money that are currently not allocated to any envelope;
- The balance for all your envelopes are still `0.00` because they were just created, and are still empty;
- In **Total balance**, you can see the sum of your envelopes, and this is always equal to the sum of your account balances (so you can rely on the virtual representation of your money)
- In **Unallocated**, you only get a quick view of the same information available in the current balance of the `Reserved:Unallocated` envelope. This is just to make things easier;
- **Budgeted Income** shows the sum of planned monthly budget for your income envelopes. This is what you expect to **earn every month**;
- **Budgeted Expense** shows the sum of planned monthly budget for your expense envelopes. This is what you expect to **spend every month**;
- **Difference** is, basically, `Budgeted Income - Budgeted Expense`. This should always be **zero**, meaning that you have a plan for every token you expect to earn.

> If your expenses are lesser than your earnings (which is a good thing), maybe you can think that your **Difference** will always be greater than **zero**.
>
> A difference of zero doesn't mean you should really spend all your money every month. You can create expense envelopes for allocating your money for different things, such as short-term trips, long-term investments, general savings etc.
> Having a difference of zero means that you have a plan, a virtual destination for your money. This is why envelopes are persistent and more powerful that simple budget tools.

### Filling the envelopes

As a good practice, you should always fill your envelopes at the begining of the month (if a monthly planning makes sense for you):

```bash
$ ./cash.sh transaction add-envelope-transfer --from Reserved:Unallocated --to Bills:Home --date 2025-12-01 --amount 500.00 --description "Filling envelopes"
#[2025-12-15 21:27:25] [info ] Added transaction for Reserved:Unallocated
#[2025-12-15 21:27:25] [info ] Added transaction for Bills:Home

$ ./cash.sh transaction add-envelope-transfer --from Reserved:Unallocated --to Fun:Free --date 2025-12-01 --amount 250.00 --description "Filling envelopes"
#[2025-12-15 21:28:33] [info ] Added transaction for Reserved:Unallocated
#[2025-12-15 21:28:33] [info ] Added transaction for Fun:Free

$ ./cash.sh transaction add-envelope-transfer --from Reserved:Unallocated --to Investment:Savings --date 2025-12-01 --amount 150.00 --description "Filling envelopes"
#[2025-12-15 21:29:39] [info ] Added transaction for Reserved:Unallocated
#[2025-12-15 21:29:39] [info ] Added transaction for Investment:Savings
```

> In this example, we had only **900.00** in total balance, so I adjusted the transfer amounts for some envelopes, as needed.

### Checking your transactions

Easy as:

```bash
$ ./cash.sh transaction list

# Output:
# ┌────┬───────────────┬──────────────┬────────────────┬───────────────┬────────────┬────────┬───────────────────┐
# │ ID │ Account Group │ Account Name │ Envelope Group │ Envelope Name │    Date    │ Amount │    Description    │
# ├────┼───────────────┼──────────────┼────────────────┼───────────────┼────────────┼────────┼───────────────────┤
# │ 3  │               │              │ Reserved       │ Unallocated   │ 2025-12-01 │ -500.0 │ Filling envelopes │
# │ 4  │               │              │ Bills          │ Home          │ 2025-12-01 │ 500.0  │ Filling envelopes │
# │ 5  │               │              │ Reserved       │ Unallocated   │ 2025-12-01 │ -250.0 │ Filling envelopes │
# │ 6  │               │              │ Fun            │ Free          │ 2025-12-01 │ 250.0  │ Filling envelopes │
# │ 7  │               │              │ Reserved       │ Unallocated   │ 2025-12-01 │ -150.0 │ Filling envelopes │
# │ 8  │               │              │ Investment     │ Savings       │ 2025-12-01 │ 150.0  │ Filling envelopes │
# │ 1  │ BankA         │ Checking     │ Reserved       │ Unallocated   │ 2025-12-15 │ 1000.0 │ Opening balance   │
# │ 2  │ BankA         │ MasterCard   │ Reserved       │ Unallocated   │ 2025-12-15 │ -100.0 │ Opening balance   │
# └────┴───────────────┴──────────────┴────────────────┴───────────────┴────────────┴────────┴───────────────────┘
```

### Reconciling your balances

Let's say some time has passed, and you are going to reconcile your account balances.

Your credit card balance was **-100.00**, but now it's **-200.00**:

```bash
$ ./cash.sh account reconcile --account BankA:MasterCard --balance -200.00

# Output:
# [2025-12-15 21:37:21] [info ] Starting reconciliation for account BankA:MasterCard
# [2025-12-15 21:37:21] [info ] Marked account BankA:MasterCard for reconciliation (target balance: -200.00)
# [2025-12-15 21:37:21] [warn ] Reconciliation: account BankA:MasterCard has a difference of -100.0 to reconcile.
```

The reconciliation process has started, and now you know that you have an amount of **-100.00** as a difference to reconcile.

You check your bank statements, see and register the last transaction:

```bash
$ ./cash.sh transaction add-expense --account BankA:MasterCard --envelope Fun:Free --date 2025-12-16 --amount 45.30 --description "Lunch with friends"

# Output:
# [2025-12-15 21:41:52] [info ] Added expense transaction for BankA:MasterCard
# [2025-12-15 21:41:52] [warn ] Reconciliation: account BankA:MasterCard has a difference of -54.7 to reconcile.
```

A transaction is added and, as this account reconciliation process is still open, the remaining difference value is calculated and anounced.

> Note that a transaction has an account and an envelope. This ensures that both balances are always the same.

Now, registering the last transaction before that:

```bash
$ ./cash.sh transaction add-expense --account BankA:MasterCard --envelope Fun:Free --date 2025-12-16 --amount 54.70 --description "Gift for a party"

# Output:
# [2025-12-15 21:45:15] [info ] Added expense transaction for BankA:MasterCard
# [2025-12-15 21:45:15] [info ] Account BankA:MasterCard has a difference of 0.00 and is ready to reconcile
# [2025-12-15 21:45:15] [user ] Account BankA:MasterCard will reconcile - [ENTER] to confirm, [CTRL+c] to cancel
# [2025-12-15 21:48:40] [info ] Reconciled account BankA:MasterCard
```

The transaction is added, the remaining difference for reconciliation is once again updated and, as it is now **zero**, the account can be reconciled.

> You are informed to press `ENTER` to reconcile. If you don't want to end it now, you can hit `CTRL+c` and abort the process.

### Last observations

Now that your credit card account is reconciled, let's check your accounts again.

```bash
$ ./cash.sh account list

# Output:
# ┌────┬───────┬────────────┬────────────┬─────────┬─────────────┬─────────────────┬────────────────────┐
# │ ID │ Group │    Name    │    Type    │ Balance │ Reconciled? │ Reconciled Date │ Reconciled Balance │
# ├────┼───────┼────────────┼────────────┼─────────┼─────────────┼─────────────────┼────────────────────┤
# │ 1  │ BankA │ Checking   │ bank       │ 1000.0  │ False       │                 │                    │
# │ 2  │ BankA │ MasterCard │ creditcard │ -200.0  │ True        │ 2025-12-15      │ -200.0             │
# └────┴───────┴────────────┴────────────┴─────────┴─────────────┴─────────────────┴────────────────────┘
# Total balance: 800.0
```

> Notice that you have an indication of when (and with which balance) each account was last reconciled.

## Help Me

Have you tested this CLI tool and found a bug, or did you have a nice idea? Please, register an issue and let me know.

## Future (Roadmap)

OK, this is not a proper roadmap. It is only a dump of pending ideas for me to complete before the first **real** version.

> Alfabetically sorted, because... why not?

- [ ] Add --force argument for commands that need confirmation (such as delete operations)
- [X] Add Getting Started in README.md
- [ ] Add gif in README.md
- [ ] Autocompletion
- [ ] Budget Report
- [ ] Create a dependency-check step
- [ ] Debug levels for CLI and SQL
- [X] Enhance README.md file
- [ ] Expenses by source/type Report
- [ ] Export commands (transactions/reports/etc)
- [ ] Filters on transaction list
- [ ] Income by source/type Report
- [ ] Install command
- [ ] Progress bar on envelopes
- [ ] Tool to help creating a balanced budget on envelopes
- [ ] Views are not being correctly sorted
- [ ] Warn log messages on specific situations (like unallocated money, negative envelopes, etc)