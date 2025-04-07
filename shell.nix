# shell.nix (Final Version)
let
  pkgs = import <nixpkgs> { config = { allowUnfree = true; }; };

  nodejs = pkgs.nodejs_22;
  pnpm = pkgs.nodePackages.pnpm;
  postgresql = pkgs.postgresql;
  git = pkgs.git;
  # Add Wrangler
  wrangler = pkgs.wrangler;
  
  # Updated Python setup with more test skipping
  python = (pkgs.python310.override {
    packageOverrides = self: super: {
      # Skip tests for problematic packages
      aiohttp = super.aiohttp.overridePythonAttrs (old: {
        doCheck = false;
      });
      furl = super.furl.overridePythonAttrs (old: {
        doCheck = false;
      });
      pook = super.pook.overridePythonAttrs (old: {
        doCheck = false;
      });
      sqlalchemy-utils = super.sqlalchemy-utils.overridePythonAttrs (old: {
        doCheck = false;
      });
      factory-boy = super.factory-boy.overridePythonAttrs (old: {
        doCheck = false;
      });
      mocket = super.mocket.overridePythonAttrs (old: {
        doCheck = false;
      });
      terminado = super.terminado.overridePythonAttrs (old: {
        doCheck = false;
      });
    };
  });
  
  pythonEnv = python.withPackages (ps: with ps; [
    jupyter
    pandas
    numpy
    torch-bin  # Use pre-built binary instead of building from source
    transformers
    umap-learn
    hdbscan
    matplotlib
    seaborn
    tqdm
    python-dotenv
    requests
    pip  # for installing additional packages
  ]);

in
pkgs.mkShell {
  name = "meridian-dev-shell";

  buildInputs = [
    nodejs
    pnpm
    postgresql
    git
    # Add Wrangler
    wrangler
    pythonEnv
  ];

  shellHook = ''
    echo "Entering meridian development environment..."
    # Optional: corepack enable pnpm
    echo "Node version: $(node --version)"
    echo "pnpm version: $(pnpm --version)"
    echo "PostgreSQL available: $(psql --version || echo 'Not found or server not running')"
    echo "Git version: $(git --version)"
    echo "Wrangler version: $(wrangler --version)"
    echo "Python version: $(python --version)"
    echo "Jupyter version: $(jupyter --version)"
    echo "-------------------------------------------------"
    echo "Installing additional Python packages..."
    pip install -U openai json-repair google-genai gliclass rapidfuzz retry ipywidgets widgetsnbextension pandas-profiling readtime optuna bertopic supabase
    echo "-------------------------------------------------"
    echo "Ensure configuration files are created and populated:"
    echo "  - packages/database/.env"
    echo "  - apps/scrapers/.dev.vars.local"
    echo "  - .env (in project root, optional but recommended for Nuxt SSR)"
    echo "Remember to set DATABASE_URL, SECRET_KEY, GOOGLE_AI_API_KEY."
    echo "Ensure PostgreSQL server is running."
    echo "-------------------------------------------------"
  '';
}