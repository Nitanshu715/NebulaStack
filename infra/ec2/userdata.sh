#!/bin/bash
yum update -y
yum install -y docker
systemctl start docker
systemctl enable docker

REGION="ap-south-1"
ACCOUNT_ID="640168448737"
REPO="nebulastack-app"
TAG="${image_tag}"

aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com

docker pull $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPO:$TAG

docker run -d -p 80:1337 \
-e HOST=0.0.0.0 \
-e APP_KEYS="d0f288cadeca7ca0bc4535ed205ec451dfb9eae7480cf8c41fbea6b09dd568c3,c6f821cfb29ea2a9dc5a53cd47162c9ba7d894805f23f3495e655db993be9e98,3154f489ef48cf6bac58fc273f95924159981b9724ee6d193b52ca9d330331ef,657fcf4372267fd893a17c2a302f0486fdf4493cd97caeb36560af7bb3efcb75" \
-e API_TOKEN_SALT="c6f821cfb29ea2a9dc5a53cd47162c9ba7d894805f23f3495e655db993be9e98" \
-e ADMIN_JWT_SECRET="3154f489ef48cf6bac58fc273f95924159981b9724ee6d193b52ca9d330331ef" \
-e JWT_SECRET="657fcf4372267fd893a17c2a302f0486fdf4493cd97caeb36560af7bb3efcb75" \
$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPO:$TAG