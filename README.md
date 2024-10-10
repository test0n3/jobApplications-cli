# JobApplication - CLI
## Resume
Makes easy the creation of a table that details all the job applications done during the current month. Export all the prepared images into a unique PDF that contains in order, all the files.

Preparing these files: the spreadsheet and the PDF, is quite repetitive, boring and idiotic.

## Details
Images names must follow this format:

```
Platform - Company - Position.png
```

also the images have to be processed (renamed, trimmed) the same day they are snapshotted from the web. As the script takes this date for the CSV file.

The CSV format is as follow:

| Fecha | Posición | Compañia | Plataforma | Estado |
|-------|----------|----------|------------|--------|
| 2024-10-09 | Fullstack developer | Avenue Code | LinkedIn | en proceso |


## Progress
- [x] read file system and generate CSV file sorted by date
- [ ] generate unique pdf file with all the images in sorted by data

## Requirements
- Ruby, currently running version 2.7.3
- Gem [CSV](https://github.com/ruby/csv), install using: `gem install csv`

## How to run the script
The syntax to run the script is:   

```
ruby lumni.rb /path/of/interest
```

inside that path, the necessary PNG files have to be available.

Here an example of the syntax, I have tried this in a Linux machine, and it, probably work the same for MacOS.

```
ruby lumni.rb ~/Documents/OWN/Lumni/Octubre
```

this will create the file: `postulaciones_Octubre.csv` inside the described path.

## Important
This is still a work in progress, as many improvements can be made and many foolproof measures have to be considerated.
