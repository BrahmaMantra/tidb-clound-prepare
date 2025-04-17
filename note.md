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

tiup br:nightly restore db --checksum=false --db=sbtest_1000w --pd=http://10.2.106.144:2349 --storage="s3://br/sysbench/special_1000w?access-key=AKLTXCYjzvvBRNKIHExOepCw&secret-access-key=ONzaBzogBnVWz4StkRYxIakDLYLdltfPb4Pqjkrh&endpoint=http://tidbx.ks3-cn-beijing-internal.ksyuncs.com&force-path-style=true&region=Beijing&provider=ks"

sysbench --config-file=sysbench-baseline-1000w.config oltp_point_select --tables=32 --table-size=10000000 --db-ps-mode=auto --rand-type=special run > baseline-oltp_point_select_1000w.txt

## test-qc
tiup mirror set https://tiup-mirrors.pingcap.com
./tiup-cluster deploy tidb-test-qc 8.5.1  tidb-test-qc.yaml
tiup mirror set /root/tidbx-server-v8.5.1-x.1-beta-linux-amd64

password:LsWn+pE3H_^5c68@92
conn mysql:
mysql -h 10.2.106.144 -P 4030 -u root -p'LsWn+pE3H_^5c68@92'

### prepare
sysbench --config-file=sysbench-test-qc.config oltp_point_select --tables=32 --table-size=1000000 prepare
sysbench --config-file=sysbench-test-qc.config oltp_point_select --tables=32 --table-size=1000000 prewarm

sysbench --config-file=sysbench-test-qc.config oltp_point_select --tables=32 --table-size=1000000 --db-ps-mode=auto --rand-type=special run > test-qc-oltp_point_select_1000000-without-log.txt
sysbench --config-file=sysbench-test-qc.config oltp_read_only --tables=32 --table-size=1000000 --db-ps-mode=auto --rand-type=special run > test-qc-oltp_read_only_1000.txt

sysbench --config-file=sysbench-test-qc.config oltp_point_select --tables=32 --table-size=100000 --db-ps-mode=auto --rand-type=special run > test-qc-oltp_point_select_1000000-without-log.txt



tiup br:nightly restore db --checksum=false --db=sbtest_1000w --pd=http://10.2.106.144:2379 --storage="s3://br/sysbench/special_1000w?access-key=AKLTXCYjzvvBRNKIHExOepCw&secret-access-key=ONzaBzogBnVWz4StkRYxIakDLYLdltfPb4Pqjkrh&endpoint=http://tidbx.ks3-cn-beijing-internal.ksyuncs.com&force-path-style=true&region=Beijing&provider=ks"

sysbench --config-file=sysbench-test-qc.config oltp_point_select --tables=32 --table-size=10000000 --db-ps-mode=auto --rand-type=special run > test-qc-oltp_point_select_1000w.txt


./tiup-cluster patch tidb-test-qc from208/tidb-hotfix-v8.5.1-linux-arm64.tar.gz  -N 10.2.106.144:4030