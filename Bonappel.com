<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ethan Davis | Bon Appel | Senior IT Engineer</title>
    
    <script crossorigin src="https://unpkg.com/react@18/umd/react.development.js"></script>
    <script crossorigin src="https://unpkg.com/react-dom@18/umd/react-dom.development.js"></script>
    
    <script src="https://unpkg.com/@babel/standalone/babel.min.js"></script>
    
    <script src="https://cdn.tailwindcss.com"></script>
    
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;600;800&family=Playfair+Display:ital,wght@1,400;1,600&display=swap" rel="stylesheet">

    <style>
        /* Custom Styles */
        body {
            font-family: 'Montserrat', sans-serif;
            background-color: #050505;
            color: #f5f5f5;
            overflow-x: hidden;
        }
        
        .font-serif {
            font-family: 'Playfair Display', serif;
        }

        .gold-text {
            color: #fbbf24; /* Amber 400 */
            background: linear-gradient(to right, #fbbf24, #d97706, #fbbf24);
            -webkit-background-clip: text;
            background-clip: text;
            background-size: 200% auto;
            animation: shine 5s linear infinite;
        }

        .gold-border {
            border-color: #fbbf24;
        }

        .gold-bg {
            background-color: #fbbf24;
        }

        @keyframes shine {
            to {
                background-position: 200% center;
            }
        }

        /* Bon Appel Logo Reconstruction (Fallback styles) */
        .logo-container {
            display: inline-flex;
            flex-direction: column;
            align-items: center;
            line-height: 0.85;
            font-weight: 300;
            letter-spacing: -1px;
        }
        .logo-top {
            font-size: 1.8rem;
            border-bottom: 1px solid #fff;
            padding-bottom: 2px;
            width: 100%;
            text-align: center;
        }
        .logo-bottom {
            font-size: 1.8rem;
            padding-top: 2px;
            font-weight: 400;
        }

        /* Smooth Scroll */
        html {
            scroll-behavior: smooth;
        }
    </style>
</head>
<body>
    <div id="root"></div>

    <script type="text/babel">
        const { useState, useEffect } = React;

        // --- Icons (Inline SVGs for stability) ---
        const IconBase = ({ size = 24, className = "", children, ...props }) => (
            <svg 
                xmlns="http://www.w3.org/2000/svg" 
                width={size} 
                height={size} 
                viewBox="0 0 24 24" 
                fill="none" 
                stroke="currentColor" 
                strokeWidth="2" 
                strokeLinecap="round" 
                strokeLinejoin="round" 
                className={className} 
                {...props}
            >
                {children}
            </svg>
        );

        const Menu = (props) => (
            <IconBase {...props}><line x1="4" x2="20" y1="12" y2="12"/><line x1="4" x2="20" y1="6" y2="6"/><line x1="4" x2="20" y1="18" y2="18"/></IconBase>
        );
        const X = (props) => (
            <IconBase {...props}><path d="M18 6 6 18"/><path d="m6 6 12 12"/></IconBase>
        );
        const Server = (props) => (
            <IconBase {...props}><rect width="20" height="8" x="2" y="2" rx="2" ry="2"/><rect width="20" height="8" x="2" y="14" rx="2" ry="2"/><line x1="6" x2="6.01" y1="6" y2="6"/><line x1="6" x2="6.01" y1="18" y2="18"/></IconBase>
        );
        const Shield = (props) => (
            <IconBase {...props}><path d="M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z"/></IconBase>
        );
        const Cloud = (props) => (
            <IconBase {...props}><path d="M17.5 19c0-3.037-2.463-5.5-5.5-5.5S6.5 15.963 6.5 19"/><path d="M20.669 16.993c1.78-.456 2.898-2.28 2.443-4.06-.457-1.78-2.28-2.899-4.061-2.442a4.5 4.5 0 0 0-4.542-4.491h-.01a4.5 4.5 0 0 0-4.491 4.542c-1.78-.457-3.604.662-4.06 2.442-.456 1.78.662 3.604 2.442 4.06"/></IconBase>
        );
        const Smartphone = (props) => (
            <IconBase {...props}><rect width="14" height="20" x="5" y="2" rx="2" ry="2"/><path d="M12 18h.01"/></IconBase>
        );
        const Terminal = (props) => (
            <IconBase {...props}><polyline points="4 17 10 11 4 5"/><line x1="12" x2="20" y1="19" y2="19"/></IconBase>
        );
        const ExternalLink = (props) => (
            <IconBase {...props}><path d="M15 3h6v6"/><path d="M10 14 21 3"/><path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"/></IconBase>
        );
        const Mail = (props) => (
            <IconBase {...props}><rect width="20" height="16" x="2" y="4" rx="2"/><path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"/></IconBase>
        );
        const Linkedin = (props) => (
            <IconBase {...props}><path d="M16 8a6 6 0 0 1 6 6v7h-4v-7a2 2 0 0 0-2-2 2 2 0 0 0-2 2v7h-4v-7a6 6 0 0 1 6-6z"/><rect width="4" height="12" x="2" y="9"/><circle cx="4" cy="4" r="2"/></IconBase>
        );
        const Github = (props) => (
            <IconBase {...props}><path d="M15 22v-4a4.8 4.8 0 0 0-1-3.5c3 0 6-2 6-5.5.08-1.25-.27-2.48-1-3.5.28-1.15.28-2.35 0-3.5 0 0-1 0-3 1.5-2.64-.5-5.36-.5-8 0C6 2 5 2 5 2c-.3 1.15-.3 2.35 0 3.5A5.403 5.403 0 0 0 4 9c0 3.5 3 5.5 6 5.5-.39.49-.68 1.05-.85 1.65-.17.6-.22 1.23-.15 1.85v4"/><path d="M9 18c-4.51 2-5-2.7-5-2.7"/></IconBase>
        );
        const Network = (props) => (
            <IconBase {...props}><rect x="16" y="16" width="6" height="6" rx="1"/><rect x="2" y="16" width="6" height="6" rx="1"/><rect x="9" y="2" width="6" height="6" rx="1"/><path d="M5 16v-3a1 1 0 0 1 1-1h12a1 1 0 0 1 1 1v3"/><path d="M12 12V8"/></IconBase>
        );
        const Code = (props) => (
            <IconBase {...props}><polyline points="16 18 22 12 16 6"/><polyline points="8 6 2 12 8 18"/></IconBase>
        );
        const Download = (props) => (
             <IconBase {...props}><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" x2="12" y1="15" y2="3"/></IconBase>
        );


        // --- Components ---
        
        // Safe Logo Component (Handles image error safely)
        const Logo = () => {
            const [imgError, setImgError] = useState(false);

            if (imgError) {
                return (
                    <div className="logo-container font-sans text-white hover:text-amber-400 transition-colors duration-300">
                        <span className="logo-top tracking-widest">BON</span>
                        <span className="logo-bottom tracking-widest">APPEL</span>
                    </div>
                );
            }

            return (
                <img 
                    src="Bon-Appel-v3-logo-8bit-800x.png" 
                    alt="Bon Appel" 
                    className="h-16 w-auto object-contain hover:opacity-80 transition-opacity duration-300"
                    onError={() => setImgError(true)}
                />
            );
        };

        const Nav = () => {
            const [isOpen, setIsOpen] = useState(false);
            const [scrolled, setScrolled] = useState(false);

            useEffect(() => {
                const handleScroll = () => setScrolled(window.scrollY > 50);
                window.addEventListener('scroll', handleScroll);
                return () => window.removeEventListener('scroll', handleScroll);
            }, []);

            const navLinks = [
                { name: 'About', href: '#about' },
                { name: 'Experience', href: '#experience' },
                { name: 'Skills', href: '#skills' },
                { name: 'Projects', href: '#projects' },
                { name: 'Contact', href: '#contact' },
            ];

            return (
                <nav className={`fixed w-full z-50 transition-all duration-300 ${scrolled ? 'bg-black/90 backdrop-blur-md border-b border-zinc-800 py-3' : 'bg-transparent py-6'}`}>
                    <div className="max-w-7xl mx-auto px-6 flex justify-between items-center">
                        <a href="#" className="flex items-center">
                            <Logo />
                        </a>

                        {/* Desktop Menu */}
                        <div className="hidden md:flex space-x-8">
                            {navLinks.map((link) => (
                                <a 
                                    key={link.name} 
                                    href={link.href} 
                                    className="text-sm uppercase tracking-widest hover:text-amber-400 transition-colors duration-300"
                                >
                                    {link.name}
                                </a>
                            ))}
                        </div>

                        {/* Mobile Menu Button */}
                        <button className="md:hidden text-white" onClick={() => setIsOpen(!isOpen)}>
                            {isOpen ? <X size={28} /> : <Menu size={28} />}
                        </button>
                    </div>

                    {/* Mobile Menu Overlay */}
                    {isOpen && (
                        <div className="md:hidden absolute top-full left-0 w-full bg-zinc-900 border-b border-zinc-800 p-6 flex flex-col space-y-4 shadow-2xl">
                            {navLinks.map((link) => (
                                <a 
                                    key={link.name} 
                                    href={link.href} 
                                    className="text-lg text-white hover:text-amber-400"
                                    onClick={() => setIsOpen(false)}
                                >
                                    {link.name}
                                </a>
                            ))}
                        </div>
                    )}
                </nav>
            );
        };

        const Hero = () => {
            return (
                <section className="relative min-h-screen flex items-center justify-center pt-20 overflow-hidden">
                    {/* Background Texture */}
                    <div className="absolute inset-0 z-0 opacity-20 bg-[radial-gradient(ellipse_at_center,_var(--tw-gradient-stops))] from-zinc-800 via-black to-black"></div>
                    
                    <div className="relative z-10 max-w-4xl mx-auto px-6 text-center">
                        <p className="text-amber-400 uppercase tracking-[0.3em] mb-4 text-sm font-semibold animate-pulse">
                            Senior Systems Engineer
                        </p>
                        <h1 className="text-5xl md:text-7xl font-bold mb-6 text-white leading-tight">
                            The <span className="text-transparent bg-clip-text bg-gradient-to-r from-amber-200 via-amber-400 to-amber-500">Gold Standard</span> <br/>
                            in IT Infrastructure.
                        </h1>
                        <p className="text-zinc-400 text-lg md:text-xl max-w-2xl mx-auto mb-10 leading-relaxed">
                            Specializing in MDM Architecture, Cloud Migrations, and Network Stability. 
                            Turning chaotic systems into reliable assets.
                        </p>
                        <div className="flex flex-col md:flex-row justify-center gap-4">
                            <a href="#projects" className="bg-amber-500 text-black px-8 py-4 font-bold uppercase tracking-wider hover:bg-amber-400 transition-all transform hover:scale-105 rounded-sm">
                                View My Work
                            </a>
                            {/* Download Link */}
                            <a 
                                href="Ethan_Davis_CV.pdf" 
                                download 
                                className="flex items-center justify-center gap-2 border border-white text-white px-8 py-4 font-bold uppercase tracking-wider hover:bg-white hover:text-black transition-all rounded-sm"
                            >
                                <Download size={20} />
                                Download CV
                            </a>
                        </div>
                    </div>
                </section>
            );
        };

        const About = () => {
            return (
                <section id="about" className="py-24 bg-zinc-950">
                    <div className="max-w-6xl mx-auto px-6 grid md:grid-cols-2 gap-16 items-center">
                        <div className="relative">
                            <div className="absolute -top-4 -left-4 w-24 h-24 border-t-2 border-l-2 border-amber-500/50"></div>
                            <div className="absolute -bottom-4 -right-4 w-24 h-24 border-b-2 border-r-2 border-amber-500/50"></div>
                            <img 
                                src="Pose1.jpeg" 
                                alt="Ethan Davis" 
                                className="w-full h-auto grayscale hover:grayscale-0 transition-all duration-700 object-cover rounded-sm shadow-2xl border border-zinc-800"
                                onError={(e) => {
                                    e.target.style.display='none';
                                    e.target.parentNode.innerHTML = '<div class="w-full h-96 bg-zinc-900 flex items-center justify-center border border-zinc-800 text-zinc-600">Image Placeholder</div>'
                                }}
                            />
                        </div>
                        <div>
                            <h2 className="text-3xl md:text-4xl font-bold mb-6">The <span className="text-amber-400">Bon Appel</span> Philosophy</h2>
                            <h3 className="text-xl text-white italic mb-6 font-serif">"One bad apple spoils the bunch."</h3>
                            
                            <div className="space-y-4 text-zinc-400 leading-relaxed">
                                <p>
                                    In the world of IT infrastructure, this isn't just a saying—it’s a risk. A single unpatched server, a rogue mobile device, or a misconfigured firewall can compromise an entire network. I founded <strong>Bon Appel</strong> to be the antidote to that chaos.
                                </p>
                                <p>
                                    I am <strong>Ethan Davis</strong>. With over 14 years of experience, I don't just fix computers; I architect resilience. From deploying Microsoft Intune for hundreds of municipal endpoints to modernizing legacy systems for city governments, I bring a "premium" mindset to every ticket.
                                </p>
                                <p>
                                    Beyond the server room, I am a creator. My background in web development and e-commerce taught me that technology ultimately serves a business purpose. I combine the discipline of a Systems Admin with the agility of a developer to build centralized, efficient hubs that help businesses grow.
                                </p>
                            </div>

                            <div className="mt-8 flex gap-4">
                                <div className="flex items-center gap-2 text-sm text-zinc-500">
                                    <Shield size={16} className="text-amber-500" />
                                    <span>JAMF Certified</span>
                                </div>
                                <div className="flex items-center gap-2 text-sm text-zinc-500">
                                    <Cloud size={16} className="text-amber-500" />
                                    <span>Azure Specialist</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>
            );
        };

        const SkillCard = ({ icon: Icon, title, skills }) => (
            <div className="bg-zinc-900/50 border border-zinc-800 p-8 hover:border-amber-500/50 transition-colors duration-300 group">
                <div className="mb-6 inline-block p-3 bg-zinc-950 border border-zinc-800 rounded group-hover:bg-amber-500 group-hover:text-black transition-colors duration-300 text-amber-500">
                    <Icon size={24} />
                </div>
                <h3 className="text-xl font-bold mb-4 text-white">{title}</h3>
                <ul className="space-y-2">
                    {skills.map((skill, index) => (
                        <li key={index} className="text-zinc-400 text-sm flex items-center gap-2">
                            <span className="w-1.5 h-1.5 bg-amber-500 rounded-full"></span>
                            {skill}
                        </li>
                    ))}
                </ul>
            </div>
        );

        const Skills = () => {
            const skillSets = [
                {
                    icon: Cloud,
                    title: "Cloud & Identity",
                    skills: [
                        "Microsoft Entra ID (Azure)",
                        "Google Workspace & GCP",
                        "Office 365 / SharePoint",
                        "Microsoft Teams Voice"
                    ]
                },
                {
                    icon: Network,
                    title: "Networking & Security",
                    skills: [
                        "Fortigate / SonicWall / WatchGuard",
                        "HPE Aruba & Extreme Switching",
                        "EDR / XDR Security Implementation",
                        "VPN Troubleshooting"
                    ]
                },
                {
                    icon: Smartphone,
                    title: "Endpoint & Mobility",
                    skills: [
                        "Microsoft Intune (MDM)",
                        "JAMF Pro & Apple Business Mgr",
                        "VMware AirWatch",
                        "Meraki & Cradlepoint"
                    ]
                },
                {
                    icon: Server,
                    title: "Infrastructure & Apps",
                    skills: [
                        "VMware vSphere / VXrail",
                        "Windows Server & Linux",
                        "Microsoft SQL Server",
                        "AutoTask / Datto / ITGlue",
                        "BS&A & ERP Systems"
                    ]
                }
            ];

            return (
                <section id="skills" className="py-24 bg-black">
                    <div className="max-w-7xl mx-auto px-6">
                        <div className="text-center mb-16">
                            <h2 className="text-3xl md:text-4xl font-bold mb-4">Technical <span className="text-amber-400">Arsenal</span></h2>
                            <p className="text-zinc-500">The tools I use to maintain 99.9% uptime.</p>
                        </div>
                        <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
                            {skillSets.map((set, idx) => (
                                <SkillCard key={idx} {...set} />
                            ))}
                        </div>
                    </div>
                </section>
            );
        };

        const ExperienceItem = ({ role, company, years, points }) => (
            <div className="border-l-2 border-zinc-800 pl-8 pb-12 relative">
                <div className="absolute -left-[9px] top-0 w-4 h-4 rounded-full bg-amber-500"></div>
                <h3 className="text-2xl font-bold text-white">{role}</h3>
                <div className="flex justify-between items-center mb-4 mt-1">
                    <span className="text-amber-400 font-semibold">{company}</span>
                    <span className="text-zinc-500 text-sm">{years}</span>
                </div>
                <ul className="space-y-3">
                    {points.map((pt, i) => (
                        <li key={i} className="text-zinc-400 text-sm leading-relaxed">
                            {pt}
                        </li>
                    ))}
                </ul>
            </div>
        );

        const Experience = () => {
            return (
                <section id="experience" className="py-24 bg-zinc-950">
                    <div className="max-w-4xl mx-auto px-6">
                         <div className="text-center mb-16">
                            <h2 className="text-3xl md:text-4xl font-bold mb-4">Professional <span className="text-amber-400">Journey</span></h2>
                        </div>
                        
                        <div className="mt-12">
                            <ExperienceItem 
                                role="Onsite Engineer Tier II"
                                company="Skynet Innovations"
                                years="2022 - Present"
                                points={[
                                    "Spearheaded the stabilization of a major municipal client's IT infrastructure, resolving extensive legacy technical debt in VDI environments (Horizon/VXRail) and restoring critical operational capacity.",
                                    "Engineered and executed a Hybrid Intune deployment for The Senior Alliance (TSA), enabling modern device management while maintaining legacy on-premise policy requirements.",
                                    "Serve as the primary technical escalation point for Tier 1 staff, bridging the gap between high-level Project Engineering and daily operational realities.",
                                    "Managed complex hardware refreshes (250+ endpoints) and critical application licensing (Apex Draw, BS&A), transitioning the client from broken thin clients to fully functional laptops."
                                ]}
                            />
                            <ExperienceItem 
                                role="Desktop Engineer/Manager of Mobility"
                                company="RiteRug"
                                years="2018 - 2022"
                                points={[
                                    "Actively managed 1600+ mobile devices and endpoints across 60 cost centers nationwide.",
                                    "Executed M365/Active Directory administration and permissions management.",
                                    "Maintained existing patch management systems for all endpoints and made new deployment components as needed",
                                    "Led projects to increase Helpdesk Efficiency and documentation initiatives, lowering Mobility Costs Year over Year through Lean management principles."
                                ]}
                            />
                            <ExperienceItem 
                                role="Tier III/Training Manager"
                                company="The Hastings Group"
                                years="2014 - 2018"
                                points={[
                                    "Provided hands-on lifecycle management including warranty repairs, responsible recycling, and coordinating upgrade projects.",
                                    "Supported Helpdesk in a Lead role, guiding agents through difficult issues, receiving escalations, and advising on proper process and procedure.",
                                    "Developed quality assurance programs and trained new hires allowing rapid growth year over year."
                                ]}
                            />
                        </div>
                    </div>
                </section>
            );
        };

        const Projects = () => {
            return (
                <section id="projects" className="py-24 bg-black border-y border-zinc-900">
                    <div className="max-w-6xl mx-auto px-6">
                        <div className="text-center mb-16">
                            <h2 className="text-3xl md:text-4xl font-bold mb-4">Projects & <span className="text-amber-400">Ventures</span></h2>
                            <p className="text-zinc-500">Where infrastructure meets innovation.</p>
                        </div>

                        <div className="grid md:grid-cols-2 gap-8">
                            {/* Project 1: Weatherbubb */}
                            <div className="group relative overflow-hidden bg-zinc-900 border border-zinc-800 rounded-sm">
                                <div className="absolute inset-0 bg-black/70 flex items-center justify-center z-10 opacity-0 group-hover:opacity-100 transition-opacity duration-300">
                                    <span className="text-amber-400 font-bold tracking-widest uppercase">Under Construction</span>
                                </div>
                                <div className="p-8 group-hover:opacity-30 transition-opacity duration-300">
                                    <div className="flex justify-between items-start mb-6">
                                        <Cloud size={32} className="text-amber-500" />
                                        <div className="text-zinc-500"><ExternalLink size={20}/></div>
                                    </div>
                                    <h3 className="text-2xl font-bold text-white mb-2">Weatherbubb.com</h3>
                                    <p className="text-zinc-400 mb-6">A custom weather application demonstrating frontend capability and API integration.</p>
                                    <div className="flex gap-2">
                                        <span className="text-xs bg-zinc-800 text-zinc-300 px-2 py-1">React</span>
                                        <span className="text-xs bg-zinc-800 text-zinc-300 px-2 py-1">Node.js</span>
                                        <span className="text-xs bg-zinc-800 text-zinc-300 px-2 py-1">API</span>
                                    </div>
                                </div>
                            </div>

                            {/* Project 2: Automation Channels */}
                            <div className="group relative overflow-hidden bg-zinc-900 border border-zinc-800 rounded-sm">
                                <div className="absolute inset-0 bg-black/50 flex items-center justify-center z-10 opacity-0 group-hover:opacity-100 transition-opacity duration-300">
                                    <span className="text-amber-400 font-bold tracking-widest uppercase">Coming Soon</span>
                                </div>
                                <div className="p-8 opacity-50 group-hover:opacity-30 transition-opacity duration-300">
                                    <div className="flex justify-between items-start mb-6">
                                        <Terminal size={32} className="text-zinc-600" />
                                    </div>
                                    <h3 className="text-2xl font-bold text-white mb-2">Automated Content Network</h3>
                                    <p className="text-zinc-400 mb-6">An experimental network of automated content channels driven by AI agents and n8n workflows.</p>
                                    <div className="flex gap-2">
                                        <span className="text-xs bg-zinc-800 text-zinc-500 px-2 py-1">AI Agents</span>
                                        <span className="text-xs bg-zinc-800 text-zinc-500 px-2 py-1">Automation</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>
            );
        };

        const Contact = () => {
            return (
                <section id="contact" className="py-24 bg-zinc-950">
                    <div className="max-w-4xl mx-auto px-6 text-center">
                        <h2 className="text-3xl md:text-4xl font-bold mb-8">Ready to <span className="text-amber-400">Upgrade?</span></h2>
                        <p className="text-zinc-400 mb-12 max-w-2xl mx-auto">
                            Whether you need a full network audit, a custom cloud migration strategy, or just want to discuss the "Good Apple" philosophy.
                        </p>
                        
                        <div className="grid md:grid-cols-3 gap-6 mb-12">
                            <a href="mailto:edavis@bonappel.com" className="bg-zinc-900 p-6 border border-zinc-800 hover:border-amber-500 transition-all group flex flex-col items-center">
                                <Mail className="text-amber-500 mb-4 group-hover:scale-110 transition-transform" />
                                <span className="text-white font-semibold">Email Me</span>
                                <span className="text-zinc-500 text-sm mt-1">edavis@bonappel.com</span>
                            </a>
                            <a href="https://www.linkedin.com/in/ethan-davis-50a066106/" className="bg-zinc-900 p-6 border border-zinc-800 hover:border-amber-500 transition-all group flex flex-col items-center">
                                <Linkedin className="text-amber-500 mb-4 group-hover:scale-110 transition-transform" />
                                <span className="text-white font-semibold">LinkedIn</span>
                                <span className="text-zinc-500 text-sm mt-1">Connect professionally</span>
                            </a>
                            <a href="#" className="bg-zinc-900 p-6 border border-zinc-800 hover:border-amber-500 transition-all group flex flex-col items-center">
                                <Github className="text-amber-500 mb-4 group-hover:scale-110 transition-transform" />
                                <span className="text-white font-semibold">GitHub</span>
                                <span className="text-zinc-500 text-sm mt-1">Review my code</span>
                            </a>
                        </div>

                        <footer className="text-zinc-600 text-sm pt-12 border-t border-zinc-900">
                            <p>&copy; 2025 Bon Appel / Ethan Davis. All rights reserved.</p>
                            <p className="mt-2 text-xs">Based in Livonia, MI.</p>
                        </footer>
                    </div>
                </section>
            );
        };

        const App = () => {
            return (
                <div className="min-h-screen">
                    <Nav />
                    <Hero />
                    <About />
                    <Experience />
                    <Skills />
                    <Projects />
                    <Contact />
                </div>
            );
        };

        const root = ReactDOM.createRoot(document.getElementById('root'));
        root.render(<App />);
    </script>
</body>
</html>
