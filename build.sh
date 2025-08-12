#!/bin/bash
echo "=== Starting build process ==="

# Check if Node.js is available
if command -v node &> /dev/null; then
    echo "Node.js found: $(node --version)"
    echo "Building frontend..."
    cd ui
    npm install
    npm run build
    cd ..
    echo "Frontend build complete!"
else
    echo "WARNING: Node.js not found. Frontend will not be built."
    echo "The app will run in API-only mode."
fi

echo "=== Build process complete ==="