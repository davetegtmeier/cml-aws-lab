| Decision                    | Reason                                              |
| --------------------------- | --------------------------------------------------- |
| `10.224.0.0/16`             | Avoid overlap with existing home and lab networks   |
| One public subnet initially | Simplify learning and initial CML deployment        |
| VPC name: `lab`             | Infrastructure should outlive a single application  |
| AWS Name tag: `network-lab` | Describe purpose rather than implementation         |
| Build our own VPC           | Learn AWS networking instead of relying on defaults |
