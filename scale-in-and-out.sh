tiup mirror set https://tiup-mirrors.pingcap.com 
./tiup-cluster scale-in tidb-test-qc -N 10.2.106.144:4030
tiup cluster scale-out tidb-test-qc tidb-test-qc-scale-out.yaml
tiup mirror set /root/tidbx-server-v8.5.1-x.1-beta-linux-amd64