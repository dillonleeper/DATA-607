# DATA 607 Project 1: Chess Tournament Results

This folder contains the source files and deliverables for DATA 607 Project 1. The project uses R to transform a semi-structured USCF chess tournament report into a tidy dataset containing each player's name, state, total points, pre-tournament rating, and average pre-tournament rating of their opponents.

## Files

- `project1.qmd` — Quarto source document containing the Approach and complete Code Base analysis.
- `project1.html` — rendered HTML version of the Quarto document.
- `project1-results.csv` — final output table containing all 64 players and the five required fields.
- `tournament-results.txt` — instructor-provided raw tournament results.
- `ai-transcript.md` — transcript of AI interactions used while completing the assignment.
- `README.md` — project overview and reproduction notes.

## Data source

The tournament file can be read directly from this public URL:

<https://raw.githubusercontent.com/dillonleeper/DATA-607/main/assignments/week04/tournament-results.txt>

## Required output

The completed analysis produces one row for each of the 64 players with these columns:

1. Player name
2. State
3. Total points
4. Pre-tournament rating
5. Average pre-tournament rating of opponents

The assignment's validation example is Gary Hua: Ontario, 6.0 points, a pre-rating of 1794, and an average opponent pre-rating of 1605 after rounding.

## Reproducing the work

Open `project1.qmd` in RStudio and select **Render**. The analysis reads the raw data from the public GitHub URL rather than a local path. Rendering the document runs the parsing, calculation, and validation code and recreates `project1-results.csv`.

## Publication

The finished Code Base document will also be published to RPubs. The public RPubs link will be added here after publication.
