# Compose Mail From Command Line

Composing mail from command line uses the following format: mail -s <mailaddess>

For example write mail to boss@example.com
```bash
mail -s "Hello" boss@example.com
```

Then type in your message, followed by an ‘control-D’ at the beginning of a line. To stop simply type dot (.):

Output:
```bash
Hi,

This is a test
.
Cc: 
```

