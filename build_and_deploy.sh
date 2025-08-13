#!/bin/bash

# AI Agent Ecosystem Book - Build and Deploy Script
# This script builds the book and optionally deploys to GitHub Pages

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to create missing chapter files
create_missing_chapters() {
    print_status "Checking for missing chapter files..."
    
    # Array of chapter files that should exist
    declare -a chapters=(
        "chapters/02_evolution_of_agents.md"
        "chapters/03_ecosystem_overview.md"
        "chapters/04b_mcp_architecture.md"
        "chapters/05a_a2a_implementations.md"
        "chapters/05b_a2a_vs_mcp.md"
        "chapters/07_security_challenges.md"
        "chapters/08_developer_experience.md"
        "chapters/09_enterprise_adoption.md"
        "chapters/10_case_studies.md"
        "chapters/11_regional_variations.md"
        "chapters/12_emerging_patterns.md"
        "chapters/13_investment_opportunities.md"
        "chapters/14_roadmap_2030.md"
        "chapters/15_building_agents.md"
        "chapters/16_best_practices.md"
        "chapters/17_troubleshooting.md"
        "appendices/a_glossary.md"
        "appendices/b_resources.md"
        "appendices/c_code_examples.md"
        "references/bibliography.md"
    )
    
    for chapter in "${chapters[@]}"; do
        if [ ! -f "$chapter" ]; then
            print_warning "Creating placeholder for: $chapter"
            mkdir -p "$(dirname "$chapter")"
            echo "# $(basename "$chapter" .md | tr '_' ' ' | sed 's/\b\(.\)/\u\1/g')" > "$chapter"
            echo "" >> "$chapter"
            echo "```{note}" >> "$chapter"
            echo "This chapter is under development." >> "$chapter"
            echo "```" >> "$chapter"
            echo "" >> "$chapter"
            echo "## Coming Soon" >> "$chapter"
            echo "" >> "$chapter"
            echo "This section will be updated with:" >> "$chapter"
            echo "- Detailed content" >> "$chapter"
            echo "- Code examples" >> "$chapter"
            echo "- Best practices" >> "$chapter"
            echo "- Real-world applications" >> "$chapter"
        fi
    done
    
    print_success "All chapter files verified/created"
}

# Function to create images directory
setup_directories() {
    print_status "Setting up directories..."
    
    mkdir -p images
    mkdir -p _static
    mkdir -p data
    
    # Create a placeholder logo if it doesn't exist
    if [ ! -f "images/logo.png" ]; then
        print_warning "Creating placeholder logo..."
        # Create a simple SVG logo and convert to PNG if ImageMagick is available
        cat > images/logo.svg << 'EOF'
<svg width="200" height="200" xmlns="http://www.w3.org/2000/svg">
  <rect width="200" height="200" fill="#1a1a1a"/>
  <text x="100" y="100" font-family="Arial, sans-serif" font-size="24" fill="white" text-anchor="middle" dy=".3em">AI Agents</text>
</svg>
EOF
        
        if command_exists convert; then
            convert images/logo.svg images/logo.png
            rm images/logo.svg
        else
            mv images/logo.svg images/logo.png
        fi
    fi
    
    print_success "Directories ready"
}

# Function to install dependencies
install_dependencies() {
    print_status "Checking Python environment..."
    
    if ! command_exists python3; then
        print_error "Python 3 is not installed. Please install Python 3.8 or later."
        exit 1
    fi
    
    print_status "Installing/updating dependencies..."
    pip install --upgrade pip
    pip install -r requirements.txt
    
    print_success "Dependencies installed"
}

# Function to clean previous builds
clean_build() {
    print_status "Cleaning previous builds..."
    
    if [ -d "_build" ]; then
        rm -rf _build
        print_success "Cleaned _build directory"
    fi
}

# Function to build the book
build_book() {
    local format=$1
    
    case $format in
        "html")
            print_status "Building HTML version..."
            jupyter-book build . --builder html
            print_success "HTML build complete: _build/html/index.html"
            ;;
        "pdf")
            print_status "Building PDF version..."
            if command_exists xelatex || command_exists pdflatex; then
                jupyter-book build . --builder pdflatex
                print_success "PDF build complete: _build/latex/*.pdf"
            else
                print_error "LaTeX not found. Install TeX distribution for PDF output."
                return 1
            fi
            ;;
        "all")
            build_book "html"
            build_book "pdf"
            ;;
        *)
            print_error "Unknown format: $format"
            return 1
            ;;
    esac
}

# Function to serve the book locally
serve_book() {
    print_status "Starting local server..."
    print_success "Book available at: http://localhost:8000"
    print_status "Press Ctrl+C to stop the server"
    
    cd _build/html
    python3 -m http.server 8000
}

# Function to deploy to GitHub Pages
deploy_github_pages() {
    print_status "Deploying to GitHub Pages..."
    
    if ! command_exists ghp-import; then
        print_error "ghp-import not found. Installing..."
        pip install ghp-import
    fi
    
    # Check if git repository
    if [ ! -d ".git" ]; then
        print_error "Not a git repository. Initialize git first."
        return 1
    fi
    
    # Check if remote exists
    if ! git remote | grep -q "origin"; then
        print_error "No git remote 'origin' found. Add your GitHub repository as origin."
        return 1
    fi
    
    print_warning "This will deploy to GitHub Pages. Continue? (y/n)"
    read -r response
    
    if [[ "$response" =~ ^[Yy]$ ]]; then
        ghp-import -n -p -f _build/html
        print_success "Deployed to GitHub Pages!"
        print_status "Your book will be available at: https://[username].github.io/[repo-name]"
    else
        print_status "Deployment cancelled"
    fi
}

# Function to create a development environment
setup_dev_env() {
    print_status "Setting up development environment..."
    
    # Create virtual environment if it doesn't exist
    if [ ! -d "venv" ]; then
        print_status "Creating virtual environment..."
        python3 -m venv venv
        print_success "Virtual environment created"
    fi
    
    # Activate virtual environment
    print_status "Activating virtual environment..."
    source venv/bin/activate
    
    # Install dependencies in venv
    install_dependencies
    
    print_success "Development environment ready"
    print_status "To activate the environment later, run: source venv/bin/activate"
}

# Main menu
show_menu() {
    echo
    echo -e "${BLUE}AI Agent Ecosystem Book - Build System${NC}"
    echo "========================================"
    echo "1) Setup development environment"
    echo "2) Install/update dependencies"
    echo "3) Create missing chapters"
    echo "4) Build HTML"
    echo "5) Build PDF"
    echo "6) Build all formats"
    echo "7) Clean build directory"
    echo "8) Serve book locally"
    echo "9) Deploy to GitHub Pages"
    echo "10) Full build and deploy"
    echo "0) Exit"
    echo
}

# Main script logic
main() {
    # Change to script directory
    cd "$(dirname "$0")"
    
    # Check if running in book directory
    if [ ! -f "_config.yml" ]; then
        print_error "This script must be run from the book directory containing _config.yml"
        exit 1
    fi
    
    # Interactive mode if no arguments
    if [ $# -eq 0 ]; then
        while true; do
            show_menu
            read -r -p "Select an option: " choice
            
            case $choice in
                1) setup_dev_env ;;
                2) install_dependencies ;;
                3) create_missing_chapters ;;
                4) 
                    setup_directories
                    create_missing_chapters
                    build_book "html"
                    ;;
                5) 
                    setup_directories
                    create_missing_chapters
                    build_book "pdf"
                    ;;
                6) 
                    setup_directories
                    create_missing_chapters
                    build_book "all"
                    ;;
                7) clean_build ;;
                8) 
                    if [ -d "_build/html" ]; then
                        serve_book
                    else
                        print_error "No HTML build found. Build the book first."
                    fi
                    ;;
                9) 
                    if [ -d "_build/html" ]; then
                        deploy_github_pages
                    else
                        print_error "No HTML build found. Build the book first."
                    fi
                    ;;
                10)
                    setup_directories
                    create_missing_chapters
                    clean_build
                    build_book "html"
                    deploy_github_pages
                    ;;
                0) 
                    print_status "Exiting..."
                    exit 0
                    ;;
                *) 
                    print_error "Invalid option"
                    ;;
            esac
            
            if [ "$choice" != "8" ]; then
                echo
                read -r -p "Press Enter to continue..."
            fi
        done
    else
        # Command line mode
        case $1 in
            setup) setup_dev_env ;;
            install) install_dependencies ;;
            chapters) create_missing_chapters ;;
            build)
                setup_directories
                create_missing_chapters
                build_book "${2:-html}"
                ;;
            clean) clean_build ;;
            serve) serve_book ;;
            deploy) deploy_github_pages ;;
            all)
                setup_directories
                create_missing_chapters
                clean_build
                build_book "all"
                ;;
            *)
                echo "Usage: $0 [setup|install|chapters|build|clean|serve|deploy|all]"
                echo "  or run without arguments for interactive mode"
                exit 1
                ;;
        esac
    fi
}

# Run main function
main "$@"