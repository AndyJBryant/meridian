# shell.nix
let
  # Use an appropriate nixpkgs revision if needed, otherwise defaults to channel
  pkgs = import <nixpkgs> {};

  # Select appropriate package versions based on requirements
  # Node.js v22+ -> use nodejs_22
  # pnpm v9.15+ -> nodePackages.pnpm should be recent enough or use corepack from nodejs
  # Python 3.10+ -> use python312 (or 310, 311)
  # PostgreSQL -> use postgresql (latest stable)
  nodejs = pkgs.nodejs_22;
  python = pkgs.python312;
  pnpm = pkgs.nodePackages.pnpm; # Explicitly include pnpm
  postgresql = pkgs.postgresql;
  # Git is usually helpful in development environments
  git = pkgs.git;

in
pkgs.mkShell {
  name = "meridian-dev-shell";

  # Packages needed in the environment
  buildInputs = [
    nodejs
    python
    pnpm
    postgresql
    git
    # Add any other system dependencies identified during development
  ];

  # Optional: Environment variables or setup commands
  shellHook = ''
    echo "Entering meridian development environment..."
    # Enable corepack if pnpm isn't found automatically (often bundled with Node >= 16.9)
    # corepack enable pnpm
    # Set environment variables if needed, e.g.:
    # export DATABASE_URL="postgresql://user:password@localhost:5432/mydatabase"
    # Remember: Cloudflare account and Google AI API Key must be configured separately.
    echo "Node version: $(node --version)"
    echo "pnpm version: $(pnpm --version)"
    echo "Python version: $(python --version)"
    echo "PostgreSQL available: $(psql --version || echo 'Not found or server not running')"
    echo "Git version: $(git --version)"
    echo "-------------------------------------------------"
    echo "Remember to configure your Cloudflare account and Google AI API Key."
    echo "You might need to start the PostgreSQL service."
    echo "-------------------------------------------------"
  '';
}
