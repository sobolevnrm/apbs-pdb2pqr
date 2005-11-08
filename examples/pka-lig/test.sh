#!/bin/bash

if [[ $1 = "" ]]; then
    echo "Please use \"make test\" to run the tests."
    exit
fi



logfile=TESTRESULTS.log
nettime=0

input=( apbs-mol-vdw apbs-smol-vdw apbs-spl2-vdw apbs-mol-surf apbs-smol-surf apbs-spl2-surf )

results=( 8.063991082305E+00  2.095418115056E+01 1.667812105305E+01 1.108604756087E+02  1.027297303232E+02 1.667812105305E+01 )

# Initialize the results file

date=`date`
echo "Date     : ${date}" >> $logfile
echo "Directory: pka-lig" >> $logfile
echo "Results  :" >> $logfile

# For each file in the directory, run APBS and get the value

for i in 0 1 2 3 4 5
do
  echo "----------------------------------------"
  echo "Testing input file ${input[i]}.in"
  echo ""

  starttime=`date +%s`
  $1 ${input[i]}.in > ${input[i]}.out 
  answer=`grep "Global net" ${input[i]}.out | awk '{print $5}'`

  echo "Global net energy: $answer"
  sync
  if [[ $answer = ${results[i]} ]]; then
      echo "*** PASSED ***"
      echo "           ${input[i]}.in: PASSED ($answer)" >> $logfile
      pass=PASSED
  else
      echo "*** FAILED ***"
      echo "   APBS returned $answer"
      echo "   Expected result is ${results[i]}"
      echo "           ${input[i]}.in: FAILED ($answer; expected ${results[i]})" >> $logfile
      pass=FAILED
  fi
  
  endtime=`date +%s`
  let elapsed=$endtime-$starttime
  let nettime=$nettime+$elapsed
  echo "Total elapsed time: $elapsed seconds"
  echo "----------------------------------------"

done

echo "Test results have been logged to ${logfile}."
echo "Total time for this directory: ${nettime} seconds."

echo "Time     : ${nettime} seconds" >> $logfile
echo "" >> $logfile
