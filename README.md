# HomeBank Parser
This shell script will parse the CSV file created by mint.com export, and create CSV files for HomeBank to import.

# How to use
1. Read through the script and make sure you understand what it's doing.  There are several places you'll need to edit and update to fit your needs.  They're called out in comments.
2. Navigate to https://mint.intuit.com/transaction.event?startDate=11/13/2021&endDate=11/27/2021 (UPDATE THE START AND END DATE IN THIS URL)
3. At the bottom of the page, click the link that says "export all transactions"
4. Take note of the transactions at the top of the page.  The ones in itallics and slightly gray text are pending transactions.  The details of these transactions may change.  I choose to delete these from the csv file I exported, then the next time I export, I set the start date to a week prior to the end date of the previous export.  HomeBank does a good job of identifying and ignoring duplicate transactions when importing.
5. Run the shell script, passing in the csv file you exported: `./processHomeBank.sh transactions.csv`  If the script runs into an error (it likely will the first few times you run it) edit the shell script to add categories and accounts that may be missing to get_category_id() and get_account_id()
6. Open HomeBank, selct File -> Import
7. Select the csv files created by the shell script, and click through the prompts.  Make sure you select from the "Import this file into" dropdown, or HomeBank will create a new account by default.  Unfortunately there's a bug in HomeBank that they refuse to fix, where it shows "Unknown" for the file name in the left column.  If you hover your mouse over the bold "this file", it will show you the file name, which you gave a descriptive name to in the bash script.
8. Once imports are complete, you'll need to edit some transactions manually.  HomeBank can only import Expense and Income transaction types.  For something like a credit card payment, I edit the transaction and select "Transfer", and update the from and to fields.  It will usually identify the associated transaction in the other account, and let you select it after you click "ok"  If not, you may have to go to the other account and delete a duplicate transaction.
