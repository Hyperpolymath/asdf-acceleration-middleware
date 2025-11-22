//! asdf-bench - Benchmarking tool for asdf operations

use anyhow::Result;
use asdf_core::Plugin;
use asdf_metrics::{MetricsCollector, MetricsReporter};
use clap::Parser;
use colored::Colorize;
use std::time::Instant;

#[derive(Parser)]
#[command(name = "asdf-bench")]
#[command(about = "Benchmarking tool for asdf operations")]
#[command(version)]
struct Cli {
    /// Run all benchmarks
    #[arg(long)]
    all: bool,

    /// Baseline comparison (bash script)
    #[arg(long)]
    baseline: Option<String>,

    /// Output format (text, json, html)
    #[arg(long, default_value = "text")]
    format: String,

    /// Output file
    #[arg(short, long)]
    output: Option<String>,
}

fn main() -> Result<()> {
    let cli = Cli::parse();

    println!("{}", "asdf-bench - Performance Benchmarking".bright_cyan().bold());
    println!("{}", "═══════════════════════════════════".bright_black());
    println!();

    let mut collector = MetricsCollector::new();

    // Benchmark: List plugins
    println!("{} Benchmarking: List plugins", "→".cyan());
    collector.start();

    let start = Instant::now();
    let plugins = Plugin::list()?;
    let duration = start.elapsed();

    collector.record_success();

    println!(
        "  {} Found {} plugins in {:.2}s",
        "✓".green(),
        plugins.len(),
        duration.as_secs_f64()
    );

    // System info
    let system_info = MetricsCollector::system_info();

    // Generate report
    match cli.format.as_str() {
        "json" => {
            let json = MetricsReporter::to_json(collector.metrics(), &system_info)?;
            if let Some(output) = cli.output {
                std::fs::write(output, json)?;
            } else {
                println!("{}", json);
            }
        }
        "html" => {
            println!("{} HTML output not yet implemented", "!".yellow());
        }
        _ => {
            let report = MetricsReporter::format_colored_report(collector.metrics(), &system_info);
            println!("{}", report);
        }
    }

    Ok(())
}
