#!/bin/bash

FILE=$1

# ===============================================
# get_category_id() maps the categories that mint 
#   assigns (sometimes seemingly at random) to 
#   categories you use in HomeBank.  You'll need 
#   to update and add to these to fit your needs.
#   I've included some examples here.
# ===============================================

get_category_id(){
	case "$category" in
      'Shopping') category="Groceries"
              ;;
      'Health Insurance') category="Insurance"
              ;;
      'Home Improvement') category="Home"
              ;;
      'Food & Dining') category="Restaurants"
              ;;
      'Fast Food') category="Restaurants"
              ;;
      'Federal Tax') category="Taxes"
              ;;
      'Utilities') category="Utilities"
              ;;
      'Credit Card Payment') category="Credit Card Payment"
              ;;
      'Income') category="Income"
              ;;
      'Transfer') category="Transfer"
              ;;
      'Paycheck') category="Paycheck"
              ;;
      *) echo "*****ERROR*****:  Unknown category: $category"     
             echo "*************ERROR**************"
             echo "*************ERROR**************"
             echo "*************ERROR**************"
             echo "*************ERROR**************"
             echo "*************ERROR**************"
             echo "*************ERROR**************"
             echo $formatted_date
             echo "descroption=$description"
             echo "orig desc=$original_description"
             echo "amount=$amount"
             echo "category=$category"
             echo "category_ID = $category_id"
             echo "account=$account_name"
             echo "account_id="
             echo "labels=$labels"
             echo "notes=$notes"
             echo "*********ERROR***********"
             exit 1	
             ;;
	esac
}


# ===============================================
# get_account_id() maps account names in the csv 
#   created by mint to account_id values to make 
#   things easier to handle later. You'll need to add
#   your own accounts.  I've left some here as examples.
#   "allocation" is a value that maps to a tag I use in HomeBank.
#   Feel free to edit to add tags that fit your needs.
# ===============================================

get_account_id(){
	case "$account_name" in
		'Personal Checking') account_id=1
			allocation="Personal"
			;;
		'American Express') account_id=2
			allocation="Personal"
			;;
		'Personal Savings') account_id=3
			allocation="Personal"
			;;
		'Amazon Prime Card') account_id=4
			allocation="Personal"
			;;
		*) echo "*****ERROR*****: Unknown Account Name: $account_name"
			echo "*************ERROR**************"
			echo "*************ERROR**************"
			echo "*************ERROR**************"
			echo "*************ERROR**************"
			echo "*************ERROR**************"
			echo "*************ERROR**************"
		        echo $formatted_date
        		echo "descroption=$description"
        		echo "orig desc=$original_description"
        		echo "amount=$amount"
       			echo "category=$category"
        		echo "category_ID = $category_id"
        		echo "account=$account_name"
        		echo "account_id="
        		echo "labels=$labels"
        		echo "notes=$notes"
			exit 1
			;;
	esac
}

# ===============================================
# convert_amount() converts the values in the mint 
#   CSV from debit and credits into positive and
#   negative values.
# ===============================================

convert_amount(){
	 if [[ "$transaction_type" == "credit" ]]
        then
                #do nothing
	              echo "credit, not making negative"
   elif [[ "$transaction_type" == "debit" ]]
        then
		            amount="-$amount"
		            #convert to netagitve
   else
           echo "*****ERROR*****:  Unknown transaction type: $transaction_type"
           echo "*****ERROR*****:  Unknown transaction type: $transaction_type"
           echo "*****ERROR*****:  Unknown transaction type: $transaction_type"
           echo "*****ERROR*****:  Unknown transaction type: $transaction_type"
           echo "*****ERROR*****:  Unknown transaction type: $transaction_type"
   fi
}


# ===============================================
# check_description() is used for debugging parsing
#   errors.  Some characters in the descriptions used
#   by mint will break the way I'm parsing.  If you
#   find additional characters that break parsing, add
#   rows to this function to replace them with something else
# ===============================================

check_description(){
#make sure there aren't any " marks in the descriptions, as it breaks the import.
#check $description and $original_description

	description=`echo $description | sed 's/\"//g'`
	original_description=`echo $original_description | sed 's/\"//g'`

}


# ===============================================
# Here's where the magic happens, if ugly code and
#   horrible practices are what you call magic.
#   Don't look too closely, it's ugly.  Yes this could
#   probably be put in some kind of loop to clean it up.
# ===============================================

get_values(){

date=$(tail -n $i $FILE | head -n 1 | perl -MText::CSV -le '
    $csv = Text::CSV->new({binary=>1});
    while ($row = $csv->getline(STDIN)){ my ($date, $description, $original_description, $amount, $transaction_type, $category, $account_name, $labels, $notes) = @$row;
            print "$date";}')

description=$(tail -n $i $FILE | head -n 1 | perl -MText::CSV -le '
    $csv = Text::CSV->new({binary=>1});
    while ($row = $csv->getline(STDIN)){ my ($date, $description, $original_description, $amount, $transaction_type, $category, $account_name, $labels, $notes) = @$row;
            print "$description";}')

original_description=$(tail -n $i $FILE | head -n 1 | perl -MText::CSV -le '
    $csv = Text::CSV->new({binary=>1});
    while ($row = $csv->getline(STDIN)){ my ($date, $description, $original_description, $amount, $transaction_type, $category, $account_name, $labels, $notes) = @$row;
            print "$original_description";}')

amount=$(tail -n $i $FILE | head -n 1 | perl -MText::CSV -le '
    $csv = Text::CSV->new({binary=>1});
    while ($row = $csv->getline(STDIN)){ my ($date, $description, $original_description, $amount, $transaction_type, $category, $account_name, $labels, $notes) = @$row;
            print "$amount";}')

transaction_type=$(tail -n $i $FILE | head -n 1 | perl -MText::CSV -le '
    $csv = Text::CSV->new({binary=>1});
    while ($row = $csv->getline(STDIN)){ my ($date, $description, $original_description, $amount, $transaction_type, $category, $account_name, $labels, $notes) = @$row;
            print "$transaction_type";}')

category=$(tail -n $i $FILE | head -n 1 | perl -MText::CSV -le '
    $csv = Text::CSV->new({binary=>1});
    while ($row = $csv->getline(STDIN)){ my ($date, $description, $original_description, $amount, $transaction_type, $category, $account_name, $labels, $notes) = @$row;
            print "$category";}')

account_name=$(tail -n $i $FILE | head -n 1 | perl -MText::CSV -le '
    $csv = Text::CSV->new({binary=>1});
    while ($row = $csv->getline(STDIN)){ my ($date, $description, $original_description, $amount, $transaction_type, $category, $account_name, $labels, $notes) = @$row;
            print "$account_name";}')

labels=$(tail -n $i $FILE | head -n 1 | perl -MText::CSV -le '
    $csv = Text::CSV->new({binary=>1});
    while ($row = $csv->getline(STDIN)){ my ($date, $description, $original_description, $amount, $transaction_type, $category, $account_name, $labels, $notes) = @$row;
            print "$labels";}')

notes=$(tail -n $i $FILE | head -n 1 | perl -MText::CSV -le '
    $csv = Text::CSV->new({binary=>1});
    while ($row = $csv->getline(STDIN)){ my ($date, $description, $original_description, $amount, $transaction_type, $category, $account_name, $labels, $notes) = @$row;
            print "$notes";}')

}


# ===============================================
# Here's where we create the new csv files, and call
#   all of the above functions.
# ===============================================

# HomeBank csv files don't include a header row.  Adding one will break the import.
# Loop through file

num_rows=$(wc -l < "$FILE")

for i in `seq 1 $num_rows`;
do
	echo "Processing row " $i "of" $num_rows

	# Get the values for the current row from the file and throw them in variables
	get_values
	
	# Ignore the header of the mint file
	if [[ "$date" == "Date" ]]
        then
                continue
  fi

	get_account_id
	convert_amount
	get_category_id
	check_description

# ===============================================
# This is where we print values to new csv files.
#   Add rows for each account, associated to the IDs
#   you used in get_account_id()
# ===============================================
  
        case "$account_id" in
                '1') echo '"'$date'","0","'$original_description'","'$description'","'$labels $notes'","'$amount'","'$category'","'$allocation'"' >> output/checking.csv
                ;;
                '2') echo '"'$date'","0","'$original_description'","'$description'","'$labels $notes'","'$amount'","'$category'","'$allocation'"' >> output/amex.csv
                ;;
                '3') echo '"'$date'","0","'$original_description'","'$description'","'$labels $notes'","'$amount'","'$category'","'$allocation'"' >> output/savings.csv
                ;;
                '4') echo '"'$date'","0","'$original_description'","'$description'","'$labels $notes'","'$amount'","'$category'","'$allocation'"' >> output/amazon.csv
                ;;
                *) echo "*****ERROR*****: Unknown Account ID: $account_id"
                        echo "*************ERROR**************"
                        echo "*************ERROR**************"
                        echo "*************ERROR**************"
                        echo "*************ERROR**************"
                        echo "*************ERROR**************"
                        echo "*************ERROR**************"
                        exit 1
                        ;;
        esac

	echo "Done Processing row " $i "of" $num_rows
done
