#!/bin/sh

NAMESPACE=django-pg
ROLE=cdpipe
USER=github-actions

kubectl create ns ${NAMESPACE}
kubectl -n ${NAMESPACE} create role ${ROLE}
kubectl -n ${NAMESPACE} create role ${ROLE} --verb=create,delete,get,list,update --resource=pods,secret,ingresses,services,replicasets,statefulset
kubectl -n ${NAMESPACE} create rolebinding ${ROLE}-bind --role=${ROLE} --user=${USER}

openssl genrsa -out ${USER}.key 2048
openssl req -new -key ${USER}.key -subj "/CN=${USER}" -out ${USER}.csr

export REQUEST=$(cat ${USER}.csr | base64 -w 0)
cat << EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: $USER
spec:
  groups:
  - system:authenticated
  request: $REQUEST
  signerName: kubernetes.io/kube-apiserver-client
  usages:
  - client auth
EOF

kubectl certificate approve ${USER}
kubectl get csr ${USER} -o jsonpath='{.status.certificate}' | base64 -d > ${USER}.crt
kubectl config set-credentials ${USER} --client-key=${USER}.key --client-certificate=${USER}.crt --embed-certs
