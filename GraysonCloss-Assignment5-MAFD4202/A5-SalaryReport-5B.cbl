       identification division.
       program-id. A5-SalaryReport-5B.
       author. name. Grayson Closs.
       date-written. date. 2023-03-19
      * This the secondary cbl file for Assignment 5. You can think of
      *  this one as Penn and the other main file Teller

       environment division.
       configuration section.

       input-output section.
       file-control.

         select salary-report-in
             assign to "../../../data/A5-SalaryData-NonGrad.dat"
             organization is line sequential.

         select salary-report-out
             assign to "../../../data/A5-SalaryReport-5B.out"
             organization is line sequential.

      *
       data division.
      *
       file section.
      * open input file as sales rec
       fd salary-report-in
           data record is salery-rec
           record contains 28 characters.
      * store sales-rec input file jargin in variables
       01 salery-rec.
         05 sr-emp-num         pic 999.
         05 sr-name            pic x(15).
         05 sr-years           pic 99.
         05 sr-edu-code        pic x.
         05 sr-salary          pic 9(5)v99.
         05 sr-budget-estimate pic 9(6)v99.

       fd salary-report-out
       data record is salary-line
       record contains 106 characters.
      * the size of the report-line
       01 salary-line          pic x(106).

       working-storage section.
      * important vars for calcs
       01 ws-eof-flag          pic x value 'N'.
       01 ws-line-count        pic 99 value 0.
       01 ws-pg-break          pic x value X'0C'.

      * first heading that contains name date and student id
       01 ws-heading-name-line.
         05 ws-header-name     pic x(31) value
                           "Grayson Closs, Assignment 5, 5B".
         05 filler             pic x(11) value spaces.
         05 ws-date            pic 9(8) value 20231803.
         05 filler             pic x(21) value spaces.
         05 ws-id              pic 9(9) value 100597686.
      * the main header for each page
       01 ws-heading-title.
         05 filler             pic x(26) value spaces.
         05 ws-title           pic x(31) value
         "NON-GRAD EMPLOYEE SALARY REPORT".
         05 filler             pic x(14) value spaces.
         05 ws-pg-str-title    pic x(4) value "PAGE".
         05 filler             pic x(2) value spaces.
         05 ws-pg-num-title    pic 9 value 1.
      * The first part for the page header
       01 ws-page-header-one.
         05 filler             pic x value spaces.
         05 ws-emp-num-one     pic x(3) value "EMP".
         05 filler             pic x(2) value spaces.
         05 ws-emp-name-one    pic x(3) value "EMP".
         05 filler             pic x(28) value spaces.
         05 ws-sal-one         pic x(7) value "PRESENT".
         05 filler             pic x(2) value spaces.
         05 ws-inc-one         pic x(8) value "INCREASE".
         05 filler             pic x(5) value spaces.
         05 ws-pay-one         pic x(3) value "PAY".
         05 filler             pic x(11) value spaces.
         05 ws-new-one         pic x(3) value "NEW".
         05 filler             pic x(9) value spaces.
         05 ws-budget-one      pic x(6) value "BUDGET".
         05 filler             pic x(9) value spaces.
         05 ws-diff-one        pic x(3) value "NEW".
      * The second part for the page header
       01 ws-page-header-two.
         05 filler             pic x value spaces.
         05 ws-emp-num-two     pic x(3) value "NUM".
         05 filler             pic x(2) value spaces.
         05 ws-emp-name-two    pic x(4) value "NAME".
         05 filler             pic x(10) value spaces.
         05 ws-years-two       pic x(5) value "YEARS".
         05 filler             pic x value spaces.
         05 ws-pos-two         pic x(8) value "POSITION".
         05 filler             pic x(4) value spaces.
         05 ws-sal-two         pic x(6) value "SALARY".
         05 filler             pic x(5) value spaces.
         05 ws-inc-two         pic x value "%".
         05 filler             pic x(7) value spaces.
         05 ws-pay-two         pic x(8) value "INCREASE".
         05 filler             pic x(7) value spaces.
         05 ws-new-two         pic x(6) value "SALARY".
         05 filler             pic x(6) value spaces.
         05 ws-budget-two      pic x(8) value "ESTIMATE".
         05 filler             pic x(4) value spaces.
         05 ws-diff-one        pic x(10) value "DIFFERENCE".
      * the guts of the operation
       01 ws-detail-line.
         05 filler             pic x value spaces.
         05 ws-num             pic 999.
         05 filler             pic x value spaces.
         05 ws-name            pic x(15).
         05 filler             pic x(2) value spaces.
         05 ws-year            pic zz.
         05 filler             pic x(2) value spaces.
         05 ws-position        pic x(8).
         05 filler             pic x(2) value spaces.
         05 ws-salary          pic z(2),z(3).9(2).
         05 filler             pic x(2) value spaces.
         05 ws-increase-per    pic zz.z.
         05 ws-per-detail      pic x value "%".
         05 filler             pic x(3) value spaces.
         05 ws-increase-pay    pic $$$,$99.9(2)+.
         05 filler             pic x value spaces.
         05 ws-new-sal         pic $z(1),z(3),z(3).z(2).
         05 filler             pic x(2) value spaces.
         05 ws-budget-est      pic $z(3),z(3).z(2).
         05 filler             pic x(2) value spaces.
         05 ws-diff            pic -(3),-(2)9.99.

      * the footer for each pages pt 1
       01 ws-footer-title.
         05 filler             pic x value spaces.
         05 ws-emp-class       pic x(15) value "EMPLOYEE CLASS:".
         05 filler             pic x(8) value spaces.
         05 ws-emp-analyst     pic x(7) value "Analyst".
         05 filler             pic x(4) value spaces.
         05 ws-sen             pic x(8) value "Sen Prog".
         05 filler             pic x(4) value spaces.
         05 ws-prog            pic x(4) value "Prog".
         05 filler             pic x(4) value spaces.
         05 ws-jr-prog         pic x(7) value "Jr Prog".
         05 filler             pic x(4) value spaces.
         05 ws-unclass         pic x(12) value "Unclassified".
      * the footer for the pages pt 2
       01 ws-footer-details.
         05 filler             pic x value spaces.
         05 ws-emp-class       pic x(15) value "# ON THIS PAGE:".
         05 filler             pic x(14) value spaces.
         05 ws-analyst-count   pic 9 value 0.
         05 filler             pic x(11) value spaces.
         05 ws-sen-count       pic 9 value 0.
         05 filler             pic x(7) value spaces.
         05 ws-prog-count      pic 9 value 0.
         05 filler             pic x(10) value spaces.
         05 ws-jr-prog-count   pic 9 value 0.
         05 filler             pic x(15) value spaces.
         05 ws-un-count        pic 9 value 0.
      * the last footer for the average increase pt 1
       01 ws-average-footer-one.
         05 filler             pic x value spaces.
         05 ws-average-str     pic x(17) value "AVERAGE INCREASE:".
         05 filler             pic x(3) value spaces.
         05 ws-prog-avg-str    pic x(5) value "PROG=".
         05 filler             pic x(2) value spaces.
         05 ws-prog-avg        pic z(3),z(3).99.
         05 filler             pic x(5) value spaces.
         05 ws-jr-avg-str      pic x(8) value "JR PROG=".
         05 filler             pic x(2) value spaces.
         05 ws-jr-avg          pic z(3),z(3).99.
      * pt 2 of the average footer
       

       01 ws-budget-diff-footer.
         05 filler             pic x value spaces.
         05 filler             pic x(32) value
         "NON-GRADUATE TOTAL BUDGET DIFF: ".
         05 filler             pic x(2) value spaces.
         05 ws-tot-diff        pic $z(3),z(3).z(2).

      * 77 storage variables for calculations in our compute statments
       
       77 ws-prog-str          pic x(4) value "PROG".
       77 ws-jr-prog-str       pic x(7) value "JR PROG".
       
       77 ws-prog-per          pic 9v9 value 6.7.
       77 ws-jr-per            pic 9v9 value 3.2.
       77 ws-pay-inc           pic 9(6)v99.
       77 ws-new-sal-tmp       pic 9(6)v99.
       77 ws-diff-tmp          pic S9(6)v99.
       77 ws-tot-diff-tmp      pic S9(6)v99.

       77 ws-analyst-tot-count pic 99 value 0.
       77 ws-sen-tot-count     pic 99 value 0.
       77 ws-prog-tot-count    pic 99 value 0.
       77 ws-jr-tot-count      pic 99 value 0.
       77 ws-un-tot-count      pic 99 value 0.
       
       77 ws-prog-pay-tot      pic 9(7)v99 value 0.
       77 ws-prog-inc-tot      pic 9(7)v99 value 0.
       77 ws-jr-pay-tot        pic 9(7)v99 value 0.
       77 ws-jr-inc-tot        pic 9(7)v99 value 0.
       77 ws-lines-pr-pg       pic 99 value 20.

       procedure division.
       000-main.
      * The false brains of the operation
         perform 50-open-files.
         write salary-line from ws-heading-name-line
         before advancing 2 lines.
         perform 100-process-pages.

         perform 800-close-files.

           goback.

       50-open-files.
      * the opening of the files
         open input salary-report-in.
         open output salary-report-out.
           
       100-process-pages.

      * the brains of the operation

         perform until ws-eof-flag equals 'Y'

         perform 150-read-input
           if ws-eof-flag equals 'N' then
             perform 300-initialize-vars

             perform 200-who-is-who

             if (ws-line-count equals ws-lines-pr-pg) then

               perform 450-write-pg-footer
               perform 410-prep-pg-footer
               write salary-line from ws-pg-break
             end-if
           end-if
         end-perform.

         perform 450-write-pg-footer.
         perform 410-prep-pg-footer.
         perform 600-avg-footer.

       150-read-input.
      * reads the next line in the file and changes the flag if reaches the end
           read salary-report-in next record into salery-rec
               at end
                   move 'Y' to ws-eof-flag
           end-read.

       200-who-is-who.
      * we need to figure out who is smarticle

         if (ws-line-count < 1) then
           perform 350-write-header
         end-if.
         if sr-years greater 10 then
           perform 250-n-prog
         end-if.
         if sr-years less or equal 10
           and sr-years greater 4 then
           perform 260-n-jr-prog
         end-if.
         if sr-years less or equal 4 then
           perform 270-n-unclassified
         end-if.
         perform 250-diff-math.
         perform 400-write-pages.
           

       250-n-prog.
      * uneducated programmer calcs and counts
           move ws-prog-str    to ws-position.
           move ws-prog-per    to ws-increase-per.
           compute ws-pay-inc rounded =
             sr-salary * (ws-prog-per / 100).
           move ws-pay-inc     to ws-increase-pay.
           compute ws-new-sal-tmp = ws-pay-inc + sr-salary.
           add 1               to ws-prog-count.
           move ws-new-sal-tmp to ws-new-sal.
           add ws-new-sal-tmp  to ws-prog-inc-tot.
           add sr-salary       to ws-prog-pay-tot.

       260-n-jr-prog.
      * uneducated junior programmer calcs and counts
           move ws-jr-prog-str to ws-position.
           move ws-jr-per      to ws-increase-per.
           compute ws-pay-inc rounded =
             sr-salary * (ws-jr-per / 100).
           move ws-pay-inc     to ws-increase-pay.
           compute ws-new-sal-tmp = ws-pay-inc + sr-salary.

           add 1               to ws-jr-prog-count.
           move ws-new-sal-tmp to ws-new-sal.
           add ws-new-sal-tmp  to ws-jr-inc-tot.
           add sr-salary       to ws-jr-pay-tot.

       270-n-unclassified.
      * unedumacted unclassified person calcs and counts
         move spaces    to ws-position.
         move 0         to ws-increase-per.
         move spaces    to ws-per-detail.
         move 0.00      to ws-increase-pay.
         move sr-salary to ws-new-sal.
         add 1          to ws-un-count.
         move sr-salary to ws-new-sal-tmp.
       250-diff-math.

         compute ws-diff-tmp rounded =
           sr-budget-estimate - ws-new-sal-tmp.
         move ws-diff-tmp     to ws-diff.
         add ws-diff-tmp      to ws-tot-diff-tmp.
         move ws-tot-diff-tmp to ws-tot-diff.

       300-initialize-vars.
      * reseting variables
         move "%"                to ws-per-detail.
         move 0                  to ws-increase-pay.
         move 0                  to ws-pay-inc.
         move 0                  to ws-new-sal.
         move 0                  to ws-new-sal-tmp.
         move sr-emp-num         to ws-num.
         move sr-name            to ws-name.
         move sr-years           to ws-year.
         move sr-salary          to ws-salary.
         move sr-budget-estimate to ws-budget-est.

       350-write-header.
      * witing the header to the file
         write salary-line from ws-heading-title.
         write salary-line from ws-page-header-one
           after advancing 1 lines.
         write salary-line from ws-page-header-two
           before advancing 2 lines.

       400-write-pages.
      * writing each page witch there are five of
         write salary-line from ws-detail-line.

         add 1 to ws-line-count.

       410-prep-pg-footer.
      * calcs for the page footer
         add ws-analyst-count  to ws-analyst-tot-count.
         add ws-sen-count      to ws-sen-tot-count.
         add ws-prog-count     to ws-prog-tot-count.
         add ws-jr-prog-count  to ws-jr-tot-count.
         add ws-un-count       to ws-un-tot-count.

         move 0                to ws-analyst-count.
         move 0                to ws-sen-count.
         move 0                to ws-prog-count.
         move 0                to ws-jr-prog-count.
         move 0                to ws-un-count.

         move 0                to ws-line-count.
         add 1                 to ws-pg-num-title.

       450-write-pg-footer.
      * writing the footer for each page
         write salary-line from ws-footer-title
           after advancing 1 lines.
         write salary-line from ws-footer-details.

       600-avg-footer.
      * writing the average footer to the file
         perform 700-avg-math.

         write salary-line from ws-average-footer-one
           after advancing 1 lines.
         
         write salary-line from ws-budget-diff-footer
           after advancing 2 lines.
       700-avg-math.
      * doing all the average math for the main footer
         
         compute ws-prog-avg rounded =
           (ws-prog-inc-tot - ws-prog-pay-tot)
           / ws-prog-tot-count.

         compute ws-jr-avg rounded =
           (ws-jr-inc-tot - ws-jr-pay-tot)
           / ws-jr-tot-count.
       800-close-files.
      * def not closing the files
         close salary-report-in
           salary-report-out.
             
       end program A5-SalaryReport-5B.