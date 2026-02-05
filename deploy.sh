#!/bin/bash

# Deploy script for Flutter web app to fly.io

echo "🚀 Starting deployment to fly.io..."

# Check if flyctl is installed
if ! command -v flyctl &> /dev/null; then
    echo "❌ flyctl not found. Please install it first:"
    echo "   curl -L https://fly.io/install.sh | sh"
    exit 1
fi

# Check if logged in
if ! flyctl auth whoami &> /dev/null; then
    echo "❌ Not logged in to fly.io. Please run:"
    echo "   flyctl auth login"
    exit 1
fi

# Set up secrets first (optional)
read -p "🔐 Do you want to set up secrets? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    ./set-secrets.sh
fi

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean
flutter pub get

# Build Flutter web
echo "🔨 Building Flutter web app..."
flutter build web --release

# Deploy to fly.io
echo "🚀 Deploying to fly.io..."
flyctl deploy

# Check status
echo "✅ Deployment complete!"
echo "🌐 App URL: https://$(flyctl info --name ben-mae-the-wedding | grep Hostname | awk '{print $2}')"

echo "📊 App status:"
flyctl status