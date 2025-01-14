## _EE283 Week1_

Name: Qingyuan XIA
## Task
Write a bash script that you can submit to the hpc3 queue that downloads, uncompresses, and writes the 10th line of the file called “problem1/p.txt” and ditto from “problem1/f.txt” from the above tar archive
## Answer
To download the data, we applied "wget" to download web-based data. The bash code "tar" can uncompress the tar.data, and we will get two txt files from the link. 
To find the 10th line of the file, the "sed" can to process and manipulate text in files. 
The final answer we find is: 
10th line in f.txt: 55
10th line in p.txt: 3
## Code
```sh
cd ~
wget https://wfitch.bio.uci.edu/~tdlong/problem1.tar.gz
tar -xvf problem1.tar.gz
rm problem1.tar.gz
cd problem1
p_line10=$(sed -n '10p' "p.txt")
echo "p_line"
p_line
echo "$p_line"
p_line10=$(sed -n '10p' "p.txt")
echo "$p_line10">"p_line10.txt"
f_line10=$(sed -n '10p' "f.txt")
echo "$f_line10">"f_line10.txt"
```

