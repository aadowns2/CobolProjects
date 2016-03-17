      $set ilusing "System.Diagnostics".
       
       Identification Division.
       Program-ID. Chapter4-9M.
           Author. AnthonyDowns.
           Installation.
           Date-Written. 03/16/2016.
           Date-Compiled.
           Security.
               
       Environment Division.
           Configuration Section.
               Special-Names.
               
           Input-Output Section.
               File-Control.
                   Select EmployeeFile assign to EmployeeData
                       File Status is WS-File-Status
                       Organization is Line Sequential.
                       
                   Select SalaryFile assign to EmployeeReport
                       File Status is WS-File-Status
                       Organization is Line Sequential.
                       
       Data Division.
           File Section.
               FD  EmployeeFile
                   Record Contains 51 Characters.
                   01  Employee-Record.
                       05  In-Employee-Name        PIC X(20).
                       05  In-Employee-Salary      PIC 9(3)V9(2).
                       05  Employee-Dependents     PIC 9(1).
                       05  FICA                    PIC 9(3)V9(2).
                       05  StateTax                PIC 9(3)V9(3).   
                       05  FederalTax              PIC 9(3)V9(3).
                       05  Date-of-Hire.
                           10  Hire-Month          PIC 9(2).
                           10  Hire-Day            PIC 9(2).
                           10  Hire-Year           PIC 9(4).
               FD  SalaryFile
                   Record Contains 26 Characters.
                   01  Salary-Record.
                       05  Employee-Name           PIC X(20).
                       05  Employee-Salary         PIC $Z,Z(3).9(2).
                      
           Working-Storage Section.
           01 WS-File-Status                       PIC 9(2).
           01 Counter                              PIC 9(2).
           01 More-Records                         PIC X(1)    value 'Y'.
              88  No-More-Records                              value 'N'.
           77  SalaryIncrease                      PIC 9(3)V9(2)   value 700.00.
          
       Procedure Division.
       
       100-Initialization.
           INITIALIZE Counter
           
           OPEN INPUT EmployeeFile
               PERFORM 600-File-Validation
           OPEN OUTPUT SalaryFile
               PERFORM 600-File-Validation
           PERFORM 200-Read-Records UNTIL No-More-Records
               INVOKE TYPE Debug::WriteLine("Records Read " & Counter)
           PERFORM 500-Close-Program.
           
       200-Read-Records.
           READ EmployeeFile
               AT END SET No-More-Records TO TRUE
                   NOT at END
                       ADD 1 TO Counter
                           PERFORM 300-Calculations
                           PERFORM 400-Write-Records.
               
       300-Calculations.
           COMPUTE Employee-Salary = In-Employee-Salary + SalaryIncrease.
       
       400-Write-Records.
           MOVE In-Employee-Name TO Employee-Name.
           WRITE Salary-Record.
       
       500-Close-Program.
           CLOSE EmployeeFile
           CLOSE SalaryFile
           STOP RUN.
       
       600-File-Validation.
           EVALUATE WS-File-Status
               WHEN NOT EQUAL TO 00
                   INVOKE TYPE Debug::WriteLine("File Not Found")
               STOP RUN
           END-EVALUATE.
       
       End Program Chapter4-9M.