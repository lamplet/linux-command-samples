## 生成私钥以及自签名证书，加-nodes则生成无密码私钥。
openssl req -newkey rsa:2048 -keyout ca.key -x509 -days 365 -out ca.crt -subj "/C=CN/ST=GD/L=SZ/O=lamplet/OU=dev/CN=example.com/emailAddress=lamplet@example.com"

## 生成私钥，通过文件指定密码
openssl genrsa -passout file:passfile -out server.key 2048

## 生成私钥，通过命令行指定密码
openssl genrsa -passout pass:111111 -out server.key 2048

## 生成证书申请，通过文件指定密码
openssl req -new -key server.key -passin file:passfile -out server.csr -subj "/C=CN/ST=GD/L=SZ/O=lamplet/OU=dev/CN=example.com/emailAddress=lamplet@example.com"

## 生成证书申请，通过命令行指定密码
openssl req -new -key server.key -passin pass:111111 -out server.csr -subj "/C=CN/ST=GD/L=SZ/O=lamplet/OU=dev/CN=example.com/emailAddress=lamplet@example.com"

## 生成证书，通过文件指定密码
openssl x509 -req -days 3650 -in server.csr -CA ca.crt -CAkey ca.key -passin file:passfile -CAcreateserial -out server.crt

## 生成证书，通过命令行指定密码
openssl x509 -req -days 3650 -in server.csr -CA ca.crt -CAkey ca.key -passin pass:111111 -CAcreateserial -out server.crt
