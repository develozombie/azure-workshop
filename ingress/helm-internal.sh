figlet "Azure Helm by Jose Yapur"
echo "-----------------------------------------------------------------"
echo "Aplicando roles de Helm"
echo "-----------------------------------------------------------------"

kubectl apply -f helm-rbac.yml
sleep 5
echo "-----------------------------------------------------------------"

echo "Iniciando Helm"
echo "-----------------------------------------------------------------"
helm init --history-max 200 --service-account tiller --node-selectors "beta.kubernetes.io/os=linux"
sleep 5
echo "-----------------------------------------------------------------"

echo "Instalando Ingress Controller Interno"
echo "-----------------------------------------------------------------"

helm install stable/nginx-ingress \
    -f internal-ingress.yml \
    --set controller.replicaCount=2 \
    --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux
sleep 5
echo "-----------------------------------------------------------------"

echo "Instalando Ingress Controller Endpoint"
echo "-----------------------------------------------------------------"

kubectl apply -f ingress.yml