echo "================================================================================"
echo "INFRASTRUCTURE"
echo "================================================================================"
cd infra && ./setup.sh

echo "================================================================================"
echo "KUBENRETES CONFIGURATION"
echo "================================================================================"
cd ../conf && ./playbook.sh

echo "================================================================================"
echo "SAMPLE APPLICATION"
echo "================================================================================"
cd ../app && ./install.sh

echo "================================================================================"
echo "CHECK APPLICATION WORKING ON KUBERNETES"
echo "================================================================================"
cd ../infra && ./check_app.sh