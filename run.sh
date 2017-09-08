rgname=perf$RANDOM
numiter=2

az group create -n $rgname -l westus
echo ""

total=0
numsucceeded=0

for i in $(seq 1 $numiter)
do
    echo "starting iteration $i of $numiter"
    starttime=$(date +%s)
    
    state=$(az vmss create -n scaleset$i -g $rgname --image UbuntuLTS | grep provisioningState | cut -d '"' -f 4)
    if [ "Succeeded" == $state ]
    then
	echo ""
	echo "------------------------------"
	echo "| SUCCESS! COUNTING THIS ONE |"
	echo "------------------------------"
	echo ""
	
	endtime=$(date +%s)
	diff=$(expr $endtime - $starttime)
	total=$(expr $total + $diff)
	numsucceeded=$(expr $numsucceeded + 1)
    else
	echo ""
	echo "----------------------------------"
	echo "| FAILURE! NOT COUNTING THIS ONE |"
	echo "----------------------------------"
	echo ""
    fi
done

avg=$(expr $total / $numiter)

echo ""
echo ""
echo "number succeeded: $numsucceeded"
echo "average time: $avg seconds"
echo ""
