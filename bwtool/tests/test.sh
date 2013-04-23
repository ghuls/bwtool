#!/bin/bash

# mult tests

# multiply by 10 
lc=`bwtool -decimals=1 mult 10 A.bw /dev/stdout | diff - mult1.wig | wc -l`
if [ "$lc" -eq 0 ]; then 
    echo " "1:  passed mult1.wig test -- multiplying constants; 
else
    echo " "1:  did NOT pass mult1.wig test -- problem multiplying constants;
fi

# divide by 10
lc=`bwtool -divide -decimals=2 mult 10 A.bw /dev/stdout | diff - mult2.wig | wc -l`
if [ "$lc" -eq 0 ]; then 
    echo " "2:  passed mult2.wig test -- dividing constants; 
else
    echo " "2:  did NOT pass mult2.wig test -- problem dividing constants;
fi

# multiply by another bw (itself)
lc=`bwtool mult A.bw A.bw /dev/stdout -decimals=2 | diff - mult3.wig | wc -l`
if [ "$lc" -eq 0 ]; then 
    echo " "3:  passed mult3.wig test -- multiplying by files;
else
    echo " "3:  did NOT pass mult3.wig test -- problem multiplying by files;
fi

# multiply with NA data
lc=`bwtool mult 2 D.bw /dev/stdout -decimals=2 | diff - mult4.wig | wc -l`
if [ "$lc" -eq 0 ]; then 
    echo " "4:  passed mult4.wig test -- multiplying with NA data;
else
    echo " "4:  did NOT pass mult5.wig test -- problem multiplying with NA data;
fi

# multiply then log10
lc=`bwtool -logb=10 mult A.bw A.bw /dev/stdout -decimals=2 | diff - mult5.wig | wc -l`
if [ "$lc" -eq 0 ]; then 
    echo " "4:  passed mult5.wig test -- multiplying by file then logging;
else
    echo " "4:  did NOT pass mult5.wig test -- problem multiplying by file then logging;
fi

# shift -3 bp (upstream)
lc=`bwtool shift up 3 A.bw /dev/stdout -decimals=2 | diff - shift1.wig | wc -l`
if [ "$lc" -eq 0 ]; then 
    echo " "5:  passed shift1.wig test -- shifting upstream;
else
    echo " "5:  did NOT pass shift1.wig test -- problem shifting upstream;
fi

# shift -10 bp (upstream with NA)
lc=`bwtool shift up 10 D.bw /dev/stdout -decimals=2 | diff - shift2.wig | wc -l`
if [ "$lc" -eq 0 ]; then 
    echo " "6:  passed shift2.wig test -- shifting upstream with NA;
else
    echo " "6:  did NOT pass shift2.wig test -- problem shifting upstream with NA;
fi

# shift +5 (downstream)
lc=`bwtool shift down 5 D.bw /dev/stdout -decimals=2 | diff - shift3.wig | wc -l`
if [ "$lc" -eq 0 ]; then 
    echo " "7:  passed shift3.wig test -- shifting downstream with NA;
else
    echo " "7:  did NOT pass shift3.wig test -- problem shifting downstream with NA;
fi

# remove (less)
lc=`bwtool remove less 0.4 A.bw /dev/stdout -decimals=2 | diff - remove1.wig | wc -l`
if [ "$lc" -eq 0 ]; then 
    echo " "8:  passed remove1.wig test -- removing less than threshold;
else
    echo " "8:  did NOT pass remove1.wig test -- problem removing less than threshold;
fi

# remove (less-equal)
lc=`bwtool remove less-equal 0.4 A.bw /dev/stdout -decimals=2 | diff - remove2.wig | wc -l`
if [ "$lc" -eq 0 ]; then 
    echo " "9:  passed remove2.wig test -- removing less or equal than threshold;
else
    echo " "9:  did NOT pass remove2.wig test -- problem removing less or equal than threshold;
fi

# remove (equal)
lc=`bwtool remove equal 0.4 A.bw /dev/stdout -decimals=2 | diff - remove4.wig | wc -l`
if [ "$lc" -eq 0 ]; then 
    echo 10:  passed remove4.wig test -- removing equal to value;
else
    echo 10:  did NOT pass remove4.wig test -- problem removing equal to value;
fi

# remove (more)
lc=`bwtool remove more 0.4 A.bw /dev/stdout -decimals=1 | diff - remove5.wig | wc -l`
if [ "$lc" -eq 0 ]; then 
    echo 11:  passed remove5.wig test -- removing more than a value;
else
    echo 11:  did NOT pass remove5.wig test -- problem removing more than a value;
fi

# remove (more-equal)
lc=`bwtool remove more-equal 0.4 A.bw /dev/stdout -decimals=1 | diff - remove6.wig | wc -l`
if [ "$lc" -eq 0 ]; then 
    echo 12:  passed remove6.wig test -- removing more or equal to a value;
else
    echo 12:  did NOT pass remove6.wig test -- problem removing more or equal to a value;
fi

# remove (more-equal)
lc=`bwtool remove mask remove.bed D.bw -decimals=1 /dev/stdout | diff - remove7.wig | wc -l`
if [ "$lc" -eq 0 ]; then 
    echo 13:  passed remove7.wig test -- removing a region with NA with a mask;
else
    echo 13:  did NOT pass remove7.wig test -- problem removing a region with NA with a mask;
fi

