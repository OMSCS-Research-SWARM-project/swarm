# AI-Augmented Network Malware Analysis (AANMA)

A comprehensive graduate-level cybersecurity project combining traditional malware analysis techniques with modern AI-augmented security workflows. Students analyze the Mirai botnet through manual reverse engineering and network forensics, then build a multi-agent AI system using CrewAI to scale their analysis capabilities.

## Repository Structure

```
aanma-project/  
├── README.md  
├── autograder/  
│   ├── setup.sh  
│   ├── run_autograder  
│   ├── aanma_autograder.py  
│   └── tests/  
        # sample test cases  
│       ├── test_ioc_extraction.py  
│       ├── test_detection_rules.py  
│       └── test_agent_configs.py  
└── vmansible/  
    ├── README.md  
    ├── setup_ghidra_vm.yml
    ├── inventory.ini  
    └── Architecture_Reference.md  
```

---

## For Students: Project Overview

### What You'll Learn

This project teaches you to combine human security expertise with AI augmentation for real-world malware analysis. You'll develop skills that bridge traditional cybersecurity and modern AI-powered threat intelligence.

**Core Skills:**
- Manual malware analysis and reverse engineering
- Network traffic forensics with PCAP analysis
- Indicator of Compromise (IoC) extraction and documentation
- Multi-agent AI system development using CrewAI
- Prompt engineering for security-specific tasks
- Building scalable threat analysis workflows

### Project Structure

The project is divided into complementary parts that build on each other:

#### Part 1: Manual Malware Analysis (40 points)
You'll analyze the Mirai IoT botnet through hands-on reverse engineering:

- **Source Code Analysis**: Study Mirai's bot, loader, and C2 modules to understand distributed malware architecture
- **String Extraction**: Extract hardcoded credentials, IPs, ports, and exploits from malware artifacts
- **Infection Mechanisms**: Map telnet brute force, HTTP exploits, and default credential attacks
- **DDoS Implementation**: Examine UDP floods, TCP SYN floods, and HTTP attack patterns
- **PCAP Forensics**: Analyze real Mirai network captures showing infection and attack phases
- **Manual Packet Dissection**: Read raw packet data (ASCII/hex) to build fundamental forensics skills
- **IoC Documentation**: Create structured catalogs of malicious indicators
- **Detection Rules**: Write Snort/Suricata signatures for Mirai network patterns
- **Correlation**: Match source code functions to network traffic signatures

**Deliverable**: Answer 4 graded questions identifying specific exploits and attack types from provided samples.

#### Part 1.5: Binary Analysis with Ghidra (30-60 minutes)
You'll perform static analysis on Mirai binary executables using the pre-configured Ghidra VM:

- **VM Setup**: Import and configure the provided Ubuntu VM (available in x86_64 and ARM versions)
- **Binary Import**: Load Mirai executables into Ghidra for reverse engineering
- **String Analysis**: Extract hardcoded credentials, IPs, C2 domains, and attack payloads from binaries
- **Function Analysis**: Identify key malware functions (scanning, exploits, DDoS attacks, C2 communication)
- **Cross-Reference Analysis**: Trace how malware components interact and call each other
- **Binary-to-Network Correlation**: Document expected network signatures based on binary behavior
- **IoC Cataloging**: Build a comprehensive list of indicators discovered through binary analysis

**Purpose**: This section bridges source code understanding and network forensics, providing real-world reverse engineering practice and creating the correlation foundation for your AI agent's threat detection capabilities.

**Note**: The VM comes pre-configured with Ghidra installed and the Mirai repository cloned, minimizing setup time.

#### Part 2: AI-Augmented Analysis with CrewAI (60 points)
You'll build a multi-agent AI system to scale your analysis capabilities:

- **Agent Configuration**: Customize a predetermined multi-agent architecture through YAML configs
- **Knowledge Encoding**: Package your Part 1 findings into structured knowledge files
- **Prompt Engineering**: Design effective prompts for malware-specific reasoning tasks
- **Training Examples**: Create few-shot learning examples from your manual analysis
- **System Testing**: Validate agent performance against practice questions
- **Iteration**: Debug and refine based on agent behavior and reasoning quality

**Deliverable**: Complete multi-agent system including customized YAML configs, knowledge files, training examples, and a reflection on AI augmentation in security workflows.

### Why This Approach?

The two-part structure ensures you can't shortcut the learning by feeding raw malware data to an LLM. Your manual analysis in Part 1 becomes the foundation for teaching your AI agents in Part 2. This mirrors real-world security operations where human expertise guides AI automation.

### Time Commitment

**Total Estimated Time**: 20-30 hours over 3 weeks
- Part 1 (Manual Malware Analysis): 9-14 hours
- Part 1.5 (Binary Analysis with Ghidra): 30-60 minutes
- Part 2 (AI Agent Development): 10-15 hours

This is a graduate-level project with an expected workload of up to 10 hours per week. The 3-week timeline allows you to develop deep expertise in both manual analysis and AI-augmented workflows.

### Environment Setup

You'll work with:
- **Pre-configured Ghidra VM**: Ubuntu VM with Ghidra and Mirai repository pre-installed (available in x86_64 and ARM versions for VirtualBox/UTM)
- **Mirai Source Code**: Real botnet code from the 2016 attacks (pre-cloned in VM)
- **Mirai Binary Executables**: Compiled malware samples for static analysis
- **PCAP Files**: Network captures of Mirai infection and DDoS activity
- **Analysis Tools**: Wireshark, tshark, Ghidra for reverse engineering
- **CrewAI Framework**: Multi-agent orchestration system
- **Azure OpenAI**: LLM backend using your student credits ($100/month)

**VM Details**: The provided VM comes ready to use with Ghidra 11.2.1, all network analysis tools, and the Mirai repository already cloned. Students who prefer their own analysis environment can clone the Mirai repository and obtain the binaries independently (see `vmansible/README.md` for manual setup instructions).

### Prerequisites

Before starting, you should be familiar with:
- Basic networking concepts (TCP/IP, HTTP, DNS)
- Linux command line and text processing tools
- Python programming fundamentals
- Understanding of IoT device vulnerabilities
- Basic security concepts (exploits, payloads, C2 infrastructure)

### Getting Help

- **Documentation**: Detailed step-by-step guides are provided for both project parts
- **Discussion Forums**: Share insights on analysis techniques (not answers)
- **Office Hours**: Get help with VM setup, tool configuration, or CrewAI debugging
- **Azure Support**: If you hit credit limits or API issues

---

## For Developers: Technical Overview

### Project Architecture

This project implements a multi-tiered educational platform for teaching AI-augmented security analysis:

1. **Content Layer**: Authentic malware artifacts (Mirai source + PCAP captures)
2. **Analysis Layer**: Manual reverse engineering and forensics workflow
3. **AI Layer**: CrewAI multi-agent system for scalable threat intelligence
4. **Assessment Layer**: Automated grading infrastructure with sampling

### Design Philosophy

**Anti-Shortcut Measures:**
The two-part structure prevents students from simply feeding raw data to LLMs. Part 1 requires hands-on analysis that generates artifacts (IoCs, detection rules, correlations) which become Part 2's training data. This ensures students develop foundational security skills before leveraging AI.

**Predetermined Architecture:**
Students work with a fixed 3-agent CrewAI topology rather than designing their own architecture. This decision:
- Focuses learning on prompt engineering and knowledge encoding
- Prevents security issues from poorly designed agent workflows
- Reduces API costs by limiting agent complexity
- Ensures consistent grading criteria

**Scalability Path:**
While training data is Mirai-specific, the agent system is designed to generalize to Mirai variants and similar IoT malware families, teaching students about transfer learning in security contexts.

### Technical Components

#### Malware Artifacts (`/artifacts` - not in this repo)
- **Mirai Source Code**: Bot, loader, and C2 modules with embedded IoCs
- **Mirai Binary Executables**: Compiled malware samples for Ghidra static analysis
- **PCAP Captures**: Network traffic from controlled AWS execution
  - Infection phase: Telnet brute force, HTTP exploits, credential attacks
  - Attack phase: UDP floods, SYN floods, HTTP floods
- **Analysis Samples**: Practice questions for agent testing

#### Autograder Infrastructure (`/autograder`)
- **Gradescope Integration**: Standard Gradescope autograder structure
  - `setup.sh`: Installs dependencies and configures grading environment
  - `run_autograder`: Entry point script called by Gradescope
  - `aanma_autograder.py`: Main grading logic for both project parts
- **Test Suite** (`/tests`): Validates student IoC extraction, detection rules, and agent outputs
- **Sampling Strategy**: Cost-controlled grading that selects representative questions
- **Validation Logic**: Checks YAML syntax, knowledge file formats, agent behavior

#### VM Provisioning (`/vmansible`)
- **Pre-configured Student VM**: Distributed as OVA file (x86_64 and ARM versions) with everything pre-installed
- **Ansible Playbook**: For instructors to build the VM or students to set up custom environments
- **Automated Setup**: One-command deployment of analysis workspace
- **Tool Suite**: Ghidra 11.2.1, Wireshark, tshark, Python analysis libraries, Mirai source repository
- **Isolation**: Ensures safe handling of malware artifacts

### CrewAI Implementation Details

**Agent Topology** (Predetermined):
1. **Reconnaissance Agent**: Analyzes network traffic patterns and extracts IoCs
2. **Code Analysis Agent**: Examines source code for vulnerabilities and attack logic
3. **Correlation Agent**: Links network behavior to code functionality

**Student Customization Points:**
- Agent YAML configurations (prompts, roles, goals, backstories)
- Knowledge directory contents (IoC catalogs, analysis reports, documentation)
- Training examples (few-shot learning for specific malware behaviors)
- Task definitions and agent coordination logic

**Technical Stack:**
- CrewAI framework for multi-agent orchestration
- Azure OpenAI API (gpt-4 or gpt-3.5-turbo)
- Markdown/JSON for knowledge representation
- YAML for agent configuration

### Cost Management

**Per-Student Budget:**
- Azure student credits: $100/month
- Estimated API usage: $20-40 for complete project
- 3-week timeline fits within single monthly credit allocation

**Grading Cost Control:**
- Question sampling rather than full test suite
- Representative question selection based on IoC type coverage
- Capped iterations per grading run
- Validation of student configs before live agent execution

### Deployment Considerations

**Current Setup:**
- Students use personal Azure accounts with student credits
- Distributed execution (no central infrastructure needed)

### Security Considerations

**Malware Handling:**
- Source code and compiled binaries provided in isolated VM only
- Binaries are for static analysis only—students must never execute them
- PCAP files are sanitized captures from controlled execution
- Ghidra VM provides isolated analysis environment
- VM should be run in NAT/host-only networking mode to prevent network exposure

**Agent Security:**
- Predetermined architecture prevents injection attacks
- YAML validation before agent instantiation
- API key management through Azure credentials
- Rate limiting to prevent abuse

### Development Workflow

**Adding New Malware Samples:**
1. Execute in isolated AWS environment
2. Capture network traffic with tcpdump
3. Sanitize PCAP (remove real infrastructure IPs)
4. Document expected IoCs for grading rubric
5. Create practice questions

**Updating Agent Architecture:**
1. Modify base agent YAML templates
2. Test with reference solution
3. Update student documentation
4. Adjust grading rubric for new capabilities

**Autograder Maintenance:**
1. Review student submissions for edge cases
2. Update validation logic in `aanma_autograder.py` for common issues
3. Refine test cases based on learning objectives
4. Monitor API costs and adjust sampling in grading logic
5. Deploy updates to Gradescope: `zip -r autograder.zip autograder/`

### Project Timeline

**Week 1**: Manual and binary analysis (Parts 1 & 1.5)
- Source code analysis
- Binary analysis with Ghidra (~30-60 min)
- PCAP forensics
- IoC extraction and correlation
- Detection rule writing
- Part 1 submission

**Week 2**: AI agent development (Part 2)
- CrewAI configuration
- Knowledge encoding
- Prompt engineering
- Training examples creation

**Week 3**: Testing, iteration, and submission
- System testing and validation
- Agent refinement
- Part 2 submission and final grading

### Assessment Criteria

**Part 1 (Manual Analysis):**
- Accuracy of IoC identification from source and binaries
- Quality of detection rules
- Depth of code-to-traffic correlation
- Binary analysis findings and correlation documentation
- Completeness of documentation

**Part 2 (AI System):**
- Agent configuration quality (prompt engineering)
- Knowledge representation effectiveness
- System performance on test questions
- Reflection quality on AI limitations and capabilities

### Known Challenges

**Common Student Issues:**
- Underestimating time for manual PCAP analysis
- Over-reliance on AI without understanding fundamentals
- API cost overruns from excessive agent iterations
- YAML syntax errors in agent configs

**Technical Limitations:**
- LLM hallucination on specific CVE details
- Agent context window limits with large PCAPs
- CrewAI version compatibility across student environments
- Azure API rate limiting during peak submission times

### Contributing

When extending this project:
1. Maintain the two-part structure (no shortcuts to learning)
2. Test all changes with the autograder
3. Document new malware families with expected IoCs
4. Update VM provisioning for new tool requirements
5. Monitor student feedback on time commitment and difficulty

### Repository Maintenance

- `main` branch: Stable release for current semester
- `dev` branch: Active development for next offering
- Feature branches: New malware families, tool updates, grading improvements
- Tags: Version releases tied to specific course offerings (e.g., `fall-2025`)

---

## Quick Start for Developers

```bash
# Clone repository
git clone <repo-url>
cd aanma-project

# Provision Ghidra analysis VM
cd vmansible
ansible-playbook -i inventory.ini setup_ghidra_vm.yml

# Test autograder locally (mimics Gradescope environment)
cd ../autograder
./setup.sh
./run_autograder

# Review documentation
cat vmansible/Architecture_Reference.md
```

## License and Attribution

This project is developed for CS 6262 (Network Security) at Georgia Tech's OMSCS program. Mirai source code is used under educational fair use. Network captures are from controlled research environments with no real victim data.

---

**Project Lead**: Instructional Team, CS 6262  
**Last Updated**: December 2025  
**Version**: 1.0
