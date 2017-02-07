echo "Testing RNAfold (equilibrium probabilities):"

RETURN=0

function failed {
    RETURN=1
    echo " [ NOT OK ]"
}

function passed {
    echo " [ OK ]"
}

function testline {
  echo -en "...testing $1:\t\t"
}

# Test partition function folding (centroid, MEA, base pair- and stack probabilities)
testline "Partition function (centroid, MEA)"
RNAfold --noPS -p --MEA < ${DATADIR}/rnafold.small.seq > tmp.fold
diff=$(${DIFF} ${RNAFOLD_RESULTSDIR}/rnafold.small.pf.gold tmp.fold)
if [ "x${diff}" != "x" ] ; then failed; echo -e "$diff"; else passed; fi

testline "Partition function (base pair probabilities)"
RNAfold --noPS -p2 --auto-id --id-prefix="rnafold_pf_test" < ${DATADIR}/rnafold.small.seq > tmp.fold
for file in rnafold_pf_test_00*dp.ps
do
  diff=$(${DIFF} -I CreationDate ${RNAFOLD_RESULTSDIR}/${file} ${file})
  if [ "x${diff}" != "x" ] ; then break; fi
done
if [ "x${diff}" != "x" ] ; then failed; echo -e "$diff"; else passed; fi

testline "Partition function (stack probabilities)"
for file in rnafold_pf_test_00*dp2.ps
do
  diff=$(${DIFF} -I CreationDate ${RNAFOLD_RESULTSDIR}/${file} ${file})
  if [ "x${diff}" != "x" ] ; then break; fi
done
if [ "x${diff}" != "x" ] ; then failed; echo -e "$diff"; else passed; fi

# clean up
rm tmp.fold dot.ps
rm rnafold_pf_test_00*dp.ps rnafold_pf_test_00*dp2.ps

exit ${RETURN}