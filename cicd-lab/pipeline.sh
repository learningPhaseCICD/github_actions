#!/bin/bash
set -e 
echo "Pipeline Starting...."
echo "Stage 1: Running Tests..."
node test.js || { echo "Test Failed! Pipeline Stopped."; exit 1; }
echo "Test Passed.."
echo "Stage 2: Building Dcoker image.."
docker build -t cicd-lab:latest . || { echo "❌ Build failed!"; exit 1; }
echo "Image Built"
echo "🚀 Stage 3: Deploying"
docker stop cicd-lab-prod 2>/dev/null || true
docker rm cicd-lab-prod 2>/dev/null || true
docker run -d --name cicd-lab-prod -p 3000:3000 cicd-lab:latest
echo "🩺 Stage 4: Health Check"
sleep 2
curl -f http://localhost:3000 >/dev/null 2>&1 || { echo "❌ Health check failed!"; exit 1; }
echo "✅ App is healthy"

echo "🎉 Pipeline completed successfully!"
