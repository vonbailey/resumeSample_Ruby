The script was created using the following resources:
1) ruby 2.4.1p111 (2017-03-22 revision 58053) [x64-mingw32]
2) Selenium for Ruby
3) IDE: Eclipse Neon.3 Release (4.6.3)

Program Functionality:
1) The script will run the two scenarios requested and it will also run a negative case of putting in alpha characters for the APR and Credit Limit values.
2) The script will create a directory where it is being run from to store a log and any screen shots used to show images of the process. 

Other negative cases thaty can be created:
1) Verify that the amount drawn cannot exceed the credit limit
2) Verify the correct interest is displayed in each transaction 
3) Verify the user can successfully remove a transaction 
4) Verify that a line of credit can be edited from opening page.
5) Verify that a line of credit can be shown from opening page.
6) Verify that negative numbers cannot be used in any transaction

Bug:  The "Amount" field  on the transaction screen only allows for whole numbers. (Can enter 10, but cannot enter 10.05)
Bug:  The second scenario returns the wrong amount.  Using the test criteria supplied, the program returns a total payment of $411.89, which is .10 less than the correct answer.