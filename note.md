## mirror 
1. /root/tidbx-server-v8.5.1-x.1-beta-linux-amd64
暂时 tiup mirror set /root/tidbx-server-v8.5.1-x.1-beta-linux-amd64
暂时 tiup mirror set https://tiup-mirrors.pingcap.com 


## baseline
./tiup-cluster deploy tidb-baseline 8.5.1  tidb-single.yaml
password:*-L7uH8P0x5@tc46_W
conn mysql: 
mysql -h 10.2.106.144 -P 4010 -u root -p'*-L7uH8P0x5@tc46_W'

### prepare
sysbench --config-file=sysbench-baseline.config oltp_point_select --tables=32 --table-size=1000 prepare
sysbench --config-file=sysbench-baseline.config oltp_point_select --tables=32 --table-size=1000 prewarm

sysbench --config-file=sysbench-baseline.config oltp_point_select --tables=32 --table-size=1000 --db-ps-mode=auto --rand-type=special run > baseline-oltp_point_select_1000.txt
sysbench --config-file=sysbench-baseline.config oltp_read_only --tables=32 --table-size=1000 --db-ps-mode=auto --rand-type=special run > baseline-oltp_read_only_1000.txt

sysbench --config-file=sysbench-baseline.config oltp_point_select --tables=32 --table-size=1000 --db-ps-mode=auto --rand-type=special run > baseline-oltp_point_select_1000.txt




## test-qc
c
password:s7u26W@bZci9-*0^4T
conn mysql:
mysql -h 10.2.106.144 -P 4030 -u root -p's7u26W@bZci9-*0^4T'

### prepare
sysbench --config-file=sysbench-test-qc.config oltp_point_select --tables=32 --table-size=1000000 prepare
sysbench --config-file=sysbench-test-qc.config oltp_point_select --tables=32 --table-size=1000000 prewarm

sysbench --config-file=sysbench-test-qc.config oltp_point_select --tables=32 --table-size=1000000 --db-ps-mode=auto --rand-type=special run > test-qc-oltp_point_select_1000000-without-log.txt
sysbench --config-file=sysbench-test-qc.config oltp_read_only --tables=32 --table-size=1000000 --db-ps-mode=auto --rand-type=special run > test-qc-oltp_read_only_1000.txt

sysbench --config-file=sysbench-test-qc.config oltp_point_select --tables=32 --table-size=100000 --db-ps-mode=auto --rand-type=special run > test-qc-oltp_point_select_1000000-without-log.txt

./tiup-cluster patch tidb-test-qc from208/tidb-hotfix-v8.5.1-linux-arm64.tar.gz  -N 10.2.106.144:4030