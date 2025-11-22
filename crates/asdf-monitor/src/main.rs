//! asdf-monitor - Real-time monitoring and metrics dashboard

use anyhow::Result;
use asdf_core::Plugin;
use asdf_metrics::{MetricsCollector, MetricsReporter};
use clap::{Parser, Subcommand};
use colored::Colorize;

#[derive(Parser)]
#[command(name = "asdf-monitor")]
#[command(about = "Real-time monitoring and metrics dashboard")]
#[command(version)]
struct Cli {
    #[command(subcommand)]
    command: Commands,
}

#[derive(Subcommand)]
enum Commands {
    /// Launch interactive dashboard
    Dashboard,

    /// Export current metrics
    Metrics {
        /// Output format (text, json, prometheus)
        #[arg(long, default_value = "text")]
        format: String,

        /// Output file
        #[arg(short, long)]
        output: Option<String>,
    },

    /// Health check
    Health,
}

fn main() -> Result<()> {
    let cli = Cli::parse();

    match cli.command {
        Commands::Dashboard => dashboard(),
        Commands::Metrics { format, output } => metrics(&format, output.as_deref()),
        Commands::Health => health(),
    }
}

fn dashboard() -> Result<()> {
    println!("{}", "asdf-monitor Dashboard".bright_cyan().bold());
    println!("{}", "═══════════════════════".bright_black());
    println!();

    let system_info = MetricsCollector::system_info();

    println!("{}", "System Information:".bright_white());
    println!("  CPUs:      {}", system_info.cpu_count);
    println!(
        "  Memory:    {:.1}% ({} MB / {} MB)",
        system_info.memory_usage_percent(),
        system_info.used_memory_kb / 1024,
        system_info.total_memory_kb / 1024
    );
    println!();

    let plugins = Plugin::list()?;
    println!("{}", "asdf Status:".bright_white());
    println!("  Plugins:   {}", plugins.len());
    println!();

    println!("{} Dashboard running (Ctrl+C to exit)", "→".cyan());
    println!("{} TUI dashboard not yet implemented", "!".yellow());

    Ok(())
}

fn metrics(format: &str, output: Option<&str>) -> Result<()> {
    let collector = MetricsCollector::new();
    let system_info = MetricsCollector::system_info();

    let content = match format {
        "json" => MetricsReporter::to_json(collector.metrics(), &system_info)?,
        "prometheus" => crate::export_prometheus(collector.metrics())?,
        _ => MetricsReporter::format_colored_report(collector.metrics(), &system_info),
    };

    if let Some(path) = output {
        std::fs::write(path, &content)?;
        println!("{} Metrics written to {}", "✓".green(), path);
    } else {
        println!("{}", content);
    }

    Ok(())
}

fn export_prometheus(metrics: &asdf_metrics::Metrics) -> Result<String> {
    Ok(asdf_metrics::export_prometheus(metrics)?)
}

fn health() -> Result<()> {
    println!("{} Running health check...", "→".cyan());

    if !asdf_core::is_asdf_installed() {
        println!("{} asdf is not installed", "✗".red());
        return Ok(());
    }

    println!("{} asdf is installed", "✓".green());

    let version = asdf_core::asdf_version()?;
    println!("{} Version: {}", "✓".green(), version);

    let plugins = Plugin::list()?;
    println!("{} Plugins: {}", "✓".green(), plugins.len());

    let system_info = MetricsCollector::system_info();
    println!("{} System: {} CPUs, {:.1}% memory usage",
        "✓".green(),
        system_info.cpu_count,
        system_info.memory_usage_percent()
    );

    println!("\n{} System is healthy", "✓".green().bold());

    Ok(())
}
