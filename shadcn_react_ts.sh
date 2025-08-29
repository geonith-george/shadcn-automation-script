#!/bin/bash

# Automated shadcn/ui + Vite setup script
# Usage: ./setup-shadcn-project.sh <project-name>

PROJECT_NAME=${1:-"my-shadcn-app"}

echo "🚀 Creating new shadcn/ui project: $PROJECT_NAME"

# Create Vite project with React + TypeScript
npm create vite@latest $PROJECT_NAME -- --template react-ts
cd $PROJECT_NAME

echo "📦 Installing dependencies..."
npm install

echo "🎨 Setting up Tailwind CSS..."
npm install tailwindcss @tailwindcss/vite @types/node

echo "📝 Configuring files..."

# Replace src/index.css
cat > src/index.css << 'EOF'
@import "tailwindcss";
EOF

# Update tsconfig.json
cat > tsconfig.json << 'EOF'
{
  "files": [],
  "references": [
    {
      "path": "./tsconfig.app.json"
    },
    {
      "path": "./tsconfig.node.json"
    }
  ],
  "compilerOptions": {
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"]
    }
  }
}
EOF

# Update tsconfig.app.json
cat > tsconfig.app.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "useDefineForClassFields": true,
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "skipLibCheck": true,
    "moduleResolution": "Bundler",
    "allowImportingTsExtensions": true,
    "isolatedModules": true,
    "moduleDetection": "force",
    "noEmit": true,
    "jsx": "react-jsx",
    "strict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noFallthroughCasesInSwitch": true,
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"]
    }
  },
  "include": ["src"]
}
EOF

# Update vite.config.ts
cat > vite.config.ts << 'EOF'
import path from "path"
import tailwindcss from "@tailwindcss/vite"
import react from "@vitejs/plugin-react"
import { defineConfig } from "vite"

// https://vite.dev/config/
export default defineConfig({
  plugins: [react(), tailwindcss()],
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
  },
})
EOF

echo "🎯 Initializing shadcn/ui..."
# Initialize shadcn with defaults
npx shadcn@latest init -d

echo "🔧 Adding common components..."
npx shadcn@latest add button card input label

# Update App.tsx with example
cat > src/App.tsx << 'EOF'
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"

function App() {
  return (
    <div className="flex min-h-svh flex-col items-center justify-center p-4">
      <Card className="w-full max-w-md">
        <CardHeader>
          <CardTitle>Welcome to shadcn/ui</CardTitle>
          <CardDescription>Your project is ready to go!</CardDescription>
        </CardHeader>
        <CardContent className="space-y-4">
          <Button className="w-full">Get Started</Button>
          <p className="text-sm text-muted-foreground text-center">
            Start building amazing interfaces
          </p>
        </CardContent>
      </Card>
    </div>
  )
}

export default App
EOF

echo "✅ Setup complete! 🎉"
echo ""
echo "To get started:"
echo "  cd $PROJECT_NAME"
echo "  npm run dev"
echo ""
echo "Your shadcn/ui project is ready with:"
echo "  ✓ Vite + React + TypeScript"
echo "  ✓ Tailwind CSS configured"
echo "  ✓ shadcn/ui initialized"
echo "  ✓ Common components added (button, card, input, label)"
