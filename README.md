[![en](https://img.shields.io/badge/lang-en-red.svg)](https://github.com/pogjester/company-research-agent/blob/main/README.md)
[![zh](https://img.shields.io/badge/lang-zh-green.svg)](https://github.com/pogjester/company-research-agent/blob/main/README.zh.md)

# Agentic Company Researcher 🔍

![web ui](<static/ui-1.png>)

A multi-agent tool that generates comprehensive company research reports. The platform uses a pipeline of AI agents to gather, curate, and synthesize information about any company.

✨Check it out online! https://companyresearcher.tavily.com ✨

https://github.com/user-attachments/assets/0e373146-26a7-4391-b973-224ded3182a9

## Features

- **Multi-Source Research**: Gathers data from various sources including company websites, news articles, financial reports, and industry analyses
- **AI-Powered Content Filtering**: Uses Tavily's relevance scoring for content curation
- **Real-Time Progress Streaming**: Uses WebSocket connections to stream research progress and results
- **Dual Model Architecture**: 
  - Gemini 2.0 Flash for high-context research synthesis
  - GPT-4.1 for precise report formatting and editing
- **Modern React Frontend**: Responsive UI with real-time updates, progress tracking, and download options
- **Modular Architecture**: Built using a pipeline of specialized research and processing nodes

## Agent Framework

### Research Pipeline

The platform follows an agentic framework with specialized nodes that process data sequentially:

1. **Research Nodes**:
   - `CompanyAnalyzer`: Researches core business information
   - `IndustryAnalyzer`: Analyzes market position and trends
   - `FinancialAnalyst`: Gathers financial metrics and performance data
   - `NewsScanner`: Collects recent news and developments

2. **Processing Nodes**:
   - `Collector`: Aggregates research data from all analyzers
   - `Curator`: Implements content filtering and relevance scoring
   - `Briefing`: Generates category-specific summaries using Gemini 2.0 Flash
   - `Editor`: Compiles and formats the briefings into a final report using GPT-4.1-mini

   ![web ui](<static/agent-flow.png>)

### Content Generation Architecture

The platform leverages separate models for optimal performance:

1. **Gemini 2.0 Flash** (`briefing.py`):
   - Handles high-context research synthesis tasks
   - Excels at processing and summarizing large volumes of data
   - Used for generating initial category briefings
   - Efficient at maintaining context across multiple documents

2. **GPT-4.1 mini** (`editor.py`):
   - Specializes in precise formatting and editing tasks
   - Handles markdown structure and consistency
   - Superior at following exact formatting instructions
   - Used for:
     - Final report compilation
     - Content deduplication
     - Markdown formatting
     - Real-time report streaming

This approach combines Gemini's strength in handling large context windows with GPT-4.1-mini's precision in following specific formatting instructions.

### Content Curation System

The platform uses a content filtering system in `curator.py`:

1. **Relevance Scoring**:
   - Documents are scored by Tavily's AI-powered search
   - A minimum threshold (default 0.4) is required to proceed
   - Scores reflect relevance to the specific research query
   - Higher scores indicate better matches to the research intent

2. **Document Processing**:
   - Content is normalized and cleaned
   - URLs are deduplicated and standardized
   - Documents are sorted by relevance scores
   - Real-time progress updates are sent via WebSocket

### Real-Time Communication System

The platform implements a WebSocket-based real-time communication system:

![web ui](<static/ui-2.png>)

1. **Backend Implementation**:
   - Uses FastAPI's WebSocket support
   - Maintains persistent connections per research job
   - Sends structured status updates for various events:
     ```python
     await websocket_manager.send_status_update(
         job_id=job_id,
         status="processing",
         message=f"Generating {category} briefing",
         result={
             "step": "Briefing",
             "category": category,
             "total_docs": len(docs)
         }
     )
     ```

2. **Frontend Integration**:
   - React components subscribe to WebSocket updates
   - Updates are processed and displayed in real-time
   - Different UI components handle specific update types:
     - Query generation progress
     - Document curation statistics
     - Briefing completion status
     - Report generation progress

3. **Status Types**:
   - `query_generating`: Real-time query creation updates
   - `document_kept`: Document curation progress
   - `briefing_start/complete`: Briefing generation status
   - `report_chunk`: Streaming report generation
   - `curation_complete`: Final document statistics

## Setup

### Quick Setup (Recommended)

The easiest way to get started is using the setup script:

1. Clone the repository:
```bash
git clone https://github.com/pogjester/tavily-company-research.git
cd tavily-company-research
```

2. Make the setup script executable and run it:
```bash
chmod +x setup.sh
./setup.sh
```

The setup script will:
- Check for required Python and Node.js versions
- Optionally create a Python virtual environment (recommended)
- Install all dependencies (Python and Node.js)
- Guide you through setting up your environment variables
- Optionally start both backend and frontend servers

You'll need the following API keys ready:
- Tavily API Key
- Google Gemini API Key
- OpenAI API Key
- MongoDB URI (optional)

### Manual Setup

If you prefer to set up manually, follow these steps:

1. Clone the repository:
```bash
git clone https://github.com/pogjester/tavily-company-research.git
cd tavily-company-research
```

2. Install backend dependencies:
```bash
# Optional: Create and activate virtual environment
python -m venv .venv
source .venv/bin/activate

# Install Python dependencies
pip install -r requirements.txt
```

3. Install frontend dependencies:
```bash
cd ui
npm install
```

4. Create a `.env` file with your API keys:
```env
TAVILY_API_KEY=your_tavily_key
GEMINI_API_KEY=your_gemini_key
OPENAI_API_KEY=your_openai_key

# Optional: Enable MongoDB persistence
# MONGODB_URI=your_mongodb_connection_string
```

### Docker Setup

The application can be run using Docker and Docker Compose:

1. Clone the repository:
```bash
git clone https://github.com/pogjester/tavily-company-research.git
cd tavily-company-research
```

2. Create a `.env` file with your API keys:
```env
TAVILY_API_KEY=your_tavily_key
GEMINI_API_KEY=your_gemini_key
OPENAI_API_KEY=your_openai_key

# Optional: Enable MongoDB persistence
# MONGODB_URI=your_mongodb_connection_string
```

3. Build and start the containers:
```bash
docker compose up --build
```

This will start both the backend and frontend services:
- Backend API will be available at `http://localhost:8000`
- Frontend will be available at `http://localhost:5174`

To stop the services:
```bash
docker compose down
```

Note: When updating environment variables in `.env`, you'll need to restart the containers:
```bash
docker compose down && docker compose up
```

### Running the Application

1. Start the backend server (choose one):
```bash
# Option 1: Direct Python Module
python -m application.py

# Option 2: FastAPI with Uvicorn
uvicorn application:app --reload --port 8000
```

2. In a new terminal, start the frontend:
```bash
cd ui
npm run dev
```

3. Access the application at `http://localhost:5173`

## Usage

### Local Development

1. Start the backend server (choose one option):

   **Option 1: Direct Python Module**
   ```bash
   python -m application.py
   ```

   **Option 2: FastAPI with Uvicorn**
   ```bash
   # Install uvicorn if not already installed
   pip install uvicorn

   # Run the FastAPI application with hot reload
   uvicorn application:app --reload --port 8000
   ```

   The backend will be available at:
   - API Endpoint: `http://localhost:8000`
   - WebSocket Endpoint: `ws://localhost:8000/research/ws/{job_id}`

2. Start the frontend development server:
   ```bash
   cd ui
   npm run dev
   ```

3. Access the application at `http://localhost:5173`

### Deployment Options

The application can be deployed to various cloud platforms. Here are some common options:

#### AWS Elastic Beanstalk

1. Install the EB CLI:
   ```bash
   pip install awsebcli
   ```

2. Initialize EB application:
   ```bash
   eb init -p python-3.11 tavily-research
   ```

3. Create and deploy:
   ```bash
   eb create tavily-research-prod
   ```

#### Other Deployment Options

- **Docker**: The application includes a Dockerfile for containerized deployment
- **Heroku**: Deploy directly from GitHub with the Python buildpack
- **Google Cloud Run**: Suitable for containerized deployment with automatic scaling

Choose the platform that best suits your needs. The application is platform-agnostic and can be hosted anywhere that supports Python web applications.

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Tavily](https://tavily.com/) for the research API
- All other open-source libraries and their contributors
