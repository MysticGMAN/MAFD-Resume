       identification division.
       program-id. A7-CallCenterOpReport.
       author. .
       date-written.  .
      *Program Description: 
      *
       environment division.
       input-output section.
       file-control.
      *
           select emp-file
               assign to '../../../data/A7.dat'
               organization is line sequential.
      *
           select report-file
               assign to '../../../data/A7-CallCenterOpReport.out'
               organization is line sequential.
      *
       data division.
       file section.
      *
       fd emp-file
           data record is emp-rec
           record contains 51 characters.
      *
       01 emp-rec.
           05 emp-rec-num              pic x(3).
           05 emp-rec-name             pic x(12).
           05 emp-rec-calls            pic 9.
      *
       fd report-file
           data record is report-line
           record contains 132 characters.
      *
       01 report-line                  pic x(132).
      *
       working-storage section.
      *
      *create the necessary working storage variables
      *
       01 ws-constants.
           05 ws-number-of-months      pic 99   value 12.
      *
       01 ws-calculated-fields.
           05 ws-non-zero-month-count  pic 9(2) value 0.
      *
       01 ws-eof-flag                  pic x    value 'n'.
           88 ws-end-of-file                    value "y".
      *
       01 ws-totals.
           05 ws-grand-total           pic 9(5) value 0.
           05 ws-emp-total             pic 9(5) value 0.
           05 ws-total-no-calls        pic 9(5) value 0.
      *
       01 ws-name-line.
           05 filler                   pic x(5)
               value spaces.
           05 filler                   pic x(25)
               value '    Y o u r   N a m e    '.
      *               ----+----1----+----2----+
           05 filler                   pic x(29)
               value '                        lab 7'.
      *               ----+----1----+----2----+----
           05 filler                   pic x(5)
               value spaces.
           05 ws-name-line-date        pic 9(6).
           05 filler                   pic x(4)
               value spaces.
           05 ws-name-line-time        pic 9(8).
           05 filler                   pic x(50)
               value spaces.
      *
       01 ws-report-heading.
           05 filler                   pic x(40)
               value spaces.
           05 filler                   pic x(40)
               value 'call centre volumes for july - june     '.
      *               ----+----1----+----2----+----3----+----4
           05 filler                   pic x(40)
               value spaces.
           05 filler                   pic x(12)
               value spaces.
      *
       01 ws-heading-line1.
           05 filler                   pic x(2) value spaces.
           05 filler                   pic x(8) value 'operator'.
           05 filler                   pic x(2) value spaces.
           05 filler                   pic x(8) value 'operator'.
           05 filler                   pic x(6) value spaces.
           05 filler                   pic x(3) value 'jul'.
           05 filler                   pic x(4) value spaces.
           05 filler                   pic x(3) value 'aug'.
           05 filler                   pic x(4) value spaces.
           05 filler                   pic x(3) value 'sep'.
           05 filler                   pic x(4) value spaces.
           05 filler                   pic x(3) value 'oct'.
           05 filler                   pic x(4) value spaces.
           05 filler                   pic x(3) value 'nov'.
           05 filler                   pic x(4) value spaces.
           05 filler                   pic x(3) value 'dec'.
           05 filler                   pic x(4) value spaces.
           05 filler                   pic x(3) value 'jan'.
           05 filler                   pic x(4) value spaces.
           05 filler                   pic x(3) value 'feb'.
           05 filler                   pic x(4) value spaces.
           05 filler                   pic x(3) value 'mar'.
           05 filler                   pic x(4) value spaces.
           05 filler                   pic x(3) value 'apr'.
           05 filler                   pic x(4) value spaces.
           05 filler                   pic x(3) value 'may'.
           05 filler                   pic x(4) value spaces.
           05 filler                   pic x(3) value 'jun'.
           05 filler                   pic x(4) value spaces.
           05 filler                   pic x(5) value 'total'.
           05 filler                   pic x(4) value spaces.
           05 filler                   pic x(3) value 'avg'.
           05 filler                   pic x(4) value spaces.
           05 filler                   pic x(3) value 'rem'.
           05 filler                   pic x(3) value spaces.
      *
       01 ws-heading-line2.
           05 filler                   pic x(5) value spaces.
           05 filler                   pic x(1) value '#'.
           05 filler                   pic x(8) value spaces.
           05 filler                   pic x(4) value 'name'.
           05 filler                   pic x(114) 
               value spaces.
      *
       01 ws-detail-line.
           05 filler                   pic x(4) 
               value spaces.
           05 ws-detail-line-num       pic x(3).
           05 filler                   pic x(6) 
               value spaces.
           05 ws-detail-line-name      pic x(12).
           05 filler                   pic x(1) 
               value spaces.
           05 ws-detail-line-months    pic 9.
           05 filler                   pic x(1) 
               value spaces.
           05 ws-detail-line-total     pic zzzz9.
           05 filler                   pic x(5) 
               value spaces.
           05 ws-detail-line-avg       pic zzzz9.
           05 filler                   pic x(4) 
               value spaces.
           05 ws-detail-line-rem       pic 9.
           05 filler                   pic x(84) 
               value spaces.
      *
       01 ws-total-line1.
           05 filler                   pic x(6) 
               value spaces.
           05 filler                   pic x(35)
               value "number of operators with no calls: ".
      *               ----+----1----+----2----+----3----+
           05 ws-total-line-no-calls   pic zzzz9.
           05 filler                   pic x(86) 
               value spaces.
      *
       01 ws-total-line2.
           05 filler                   pic x(6) 
               value spaces.
           05 filler                   pic x(35)
               value "number of months with no calls:    ".
      *               ----+----1----+----2----+----3----+
           05 ws-total-line-zero-mths  pic zzzz9.
           05 filler                   pic x(86) 
               value spaces.
      *
       01 ws-total-line3.
           05 filler                   pic x(6) 
               value spaces.
           05 filler                   pic x(35)
               value "overall total calls:               ".
      *               ----+----1----+----2----+----3----+
           05 ws-total-line-calls      pic zzzz9.
           05 filler                   pic x(86) 
               value spaces.
      *
       procedure division.
      *
       000-main.
      *
      *open files  
           open input  emp-file,
                output report-file.
      *
      *get the current date & time
           accept ws-name-line-date from date.
           accept ws-name-line-time from time.
      *
      *output first headings
           perform 100-print-headings.
      *
      *process input file & output results
           perform 200-read-input-file.
      *
           perform 300-process-records 
               until ws-end-of-file.
      *
      *output total lines
           perform 400-print-totals.
      *
      *close files
           close emp-file
                 report-file.
      *
           stop run.
      *
       100-print-headings.
      *
           write report-line from ws-name-line 
               after advancing 1 line.
      *
           write report-line from ws-report-heading
               after advancing 1 line.
      *
           write report-line from ws-heading-line1 
               after advancing 2 lines.
      *
           write report-line from ws-heading-line2 
               after advancing 1 line.
      *
       200-read-input-file.
      *reads a line from input file & stores it in emp-rec
      * - unless eof is encountered in which case it sets ws-eof-flag to y
           read emp-file 
           	   at end move 'y'         to ws-eof-flag.

       300-process-records.
      * TODO: Use Perform Varying to loop through monthly calls 
      *       in each record to calculate the required values
      *       for each record and accumulate the required data
      *       for total lines


      * TODO: Implement average calculation logic 
      *       as outlined in the requirments


      * TODO: Move required data to detail line for output
      *
           move emp-rec-num            to ws-detail-line-num.
           move emp-rec-name           to ws-detail-line-name.
           move ws-emp-total           to ws-detail-line-total.


      *
      * print detail line
           write report-line from ws-detail-line
               after advancing 1 lines.
      *
      * TODO: reset fields for next record
           move 0                      to ws-emp-total.
           move 0                      to ws-non-zero-month-count.


      *
      * read next record (if any)
           perform 200-read-input-file.
      *
       400-print-totals.
      *
      * TODO: Move required data to total lines for output
      *             
           move ws-total-no-calls      to ws-total-line-no-calls.
           move ws-grand-total         to ws-total-line-calls.


      *
           write report-line from ws-total-line1
               after advancing 2 lines.
           write report-line from ws-total-line2
               after advancing 2 lines.
           write report-line from ws-total-line3
               after advancing 2 lines.
      *
       end program A7-CallCenterOpReport.