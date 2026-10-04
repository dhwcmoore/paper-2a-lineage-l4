#!/usr/bin/env python3
"""Produce publication tables and a plot from retained measurements only."""
import json
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
r=json.loads((ROOT/'experiments/scaling-v20/results.json').read_text())
s=r['summary']
def get(top,n,rows,kind='constant'):
 return next(x for x in s if (x['topology'],x['nodes'],x['rows'],x['kind'])==(top,n,rows,kind))
lines=[r'\begin{table*}[htbp]',r'\centering\small',r'\caption{Representative scaling medians (five calls, milliseconds). Fibre timing includes the graph check. All shown factor runs use a constant tuple and ground.}\label{ex:tab:scaling}',r'\begin{tabular}{@{}llrrrr@{}}',r'\toprule',r'Shape & Nodes & Records & Graph (ms) & Fibre (ms) & Peak RSS (KiB) \\',r'\midrule']
for top in ['fanout','chain']:
 for n,rows in [(8,32),(8,128),(8,512),(16,512),(32,512)]:
  x=get(top,n,rows)
  lines.append(f"{top} & {n} & {rows} & {1000*x['graph_median_seconds']:.2f} & {1000*x['fibre_median_seconds']:.2f} & {x['peak_process_rss_kib']} \\\\")
lines.extend([r'\bottomrule',r'\end{tabular}',r'\end{table*}'])
(ROOT/'document/scaling_v20_table.tex').write_text('\n'.join(lines)+'\n')
x=get('chain',32,512);w=get('chain',32,512,'early-witness');i=get('chain',32,512,'injective');small=get('chain',32,32)
text=(f"Measurements used OCaml {r['compiler']} bytecode on {r['cpu']}, with serial jobs under Linux. "
 f"The 32-node chain graph check took a median {1000*x['graph_median_seconds']:.1f}\\,ms. "
 f"For the same graph, increasing the constant-factor carrier from 32 to 512 records increased the complete fibre-wrapper median from {1000*small['fibre_median_seconds']:.1f}\\,ms to {x['fibre_median_seconds']:.2f}\\,s. "
 f"At 512 records, the injective-factor case took {i['fibre_median_seconds']:.2f}\\,s, while the early-witness case took {1000*w['fibre_median_seconds']:.1f}\\,ms. "
 "The implementation checks pairs on a retained carrier and performs tuple lookups; validation also checks duplicate record identifiers pairwise. An early fibre witness shortens the search but still pays graph and validation costs. The measurements expose these costs rather than establish an asymptotic bound. Peak process memory includes generated inputs, warm-up and all five repetitions. Figure~\\ref{ex:fig:scaling} separates carrier and graph growth.\n")
(ROOT/'document/scaling_v20_result.tex').write_text(text)
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
fig,ax=plt.subplots(1,2,figsize=(7.0,2.6),layout='constrained')
for top,style in [('fanout','-'),('chain','--')]:
 for n,col in [(8,'#35618d'),(32,'#ba542a')]:
  points=[get(top,n,rows) for rows in [32,128,512]]
  ax[0].plot([p['rows'] for p in points],[1000*p['fibre_median_seconds'] for p in points],style,marker='o',color=col,label=f'{top}, {n} nodes')
  ax[0].fill_between([p['rows'] for p in points],[1000*p['fibre_min_seconds'] for p in points],[1000*p['fibre_max_seconds'] for p in points],alpha=.12,color=col)
for top,col in [('fanout','#35618d'),('chain','#ba542a')]:
 points=[get(top,n,128) for n in [8,16,32]]
 ax[1].plot([p['nodes'] for p in points],[1000*p['graph_median_seconds'] for p in points],marker='o',color=col,label=top)
 ax[1].fill_between([p['nodes'] for p in points],[1000*p['graph_min_seconds'] for p in points],[1000*p['graph_max_seconds'] for p in points],alpha=.12,color=col)
for a in ax:
 a.set_yscale('log');a.grid(True,alpha=.25);a.set_ylabel('Median call time (ms)');a.legend(fontsize=6)
ax[0].set_xscale('log',base=2);ax[0].set_xticks([32,128,512],['32','128','512']);ax[0].set_xlabel('Carrier records (constant factor)')
ax[1].set_xticks([8,16,32]);ax[1].set_xlabel('Total lineage nodes (128 records)')
fig.savefig(ROOT/'document/scaling_v20.pdf')
fig.savefig(ROOT/'experiments/scaling-v20/scaling.png',dpi=180)
