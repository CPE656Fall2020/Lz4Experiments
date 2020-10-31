#!/bin/bash
echo "Setting up environment."
mkdir $PWD/ram
sudo mount -t tmpfs -o rw,size=1024M tmpfs $PWD/ram
cp $PWD/random $PWD/ram/.
cat << EOF >> $PWD/ram/test.sh
#!/bin/bash
total_time=100
count=0
SECONDS=0
echo "Starting Test!"
while ((SECONDS < total_time )); do
    lz4 -9f random random.lz4
    ((count=count+1))
done
echo "Done with test, number of full 50Mb compressions is \$count."
EOF
cd ram
echo "Done with setup."

echo "Beginning test in 3..."
sleep 1
echo "2..."
sleep 1
echo "1..."
sleep 1

time /bin/bash $PWD/test.sh

echo "Test finished! cleaning up..."
cd ..
rm -r $PWD/ram/*
sleep 1
sudo umount $PWD/ram
rmdir $PWD/ram
echo "Done!"
