# .mcf
The Mindless Config format (.mcf extension) is a *very* minimal configuration format designed to be easy to write, parse and implement.

```py
# An example .mcf file.
# Comments are denoted with the # symbol.
foo=bar
separator=+-=-+

space example=Spaces included!
```

---

## Specification
The terms "is/are" indicate a requirement, "should ideally" indicates a preffered method, "might want to" indicates a reccomendation and "may" indicates that something is permitted.

.mcf files are made up of lines of either comments or key-value pairs.
- Comments *are* lines starting with the `#` symbol (there are no inline comments);
- Key-value pairs *are* lines containing the `=` symbol, which splits the key and value;
- Entirely empty lines *are* ignored.

Lines *are to be* separated with a newline. Keys and values *are to be* strings.

### Invalid behaviour
- Lines with content that aren't comments or key-value pairs *are* invalid;
- Multiple appearances of the same key *are* invalid.

Invalid lines *are to be* ignored by default. You *may* implement an error checking/correcting function.

### Setting
Setter functions take a key and a value and add it to the config.

A default setter function *should ideally* either append the key to the end of the config, or replace the first existing pair of the same key. You *might want to* implement a flag or separate function that doesn't allow for overwriting.

### Getting
Getter functions take a key and return the value assigned to it.

A default getter function *should ideally* return an empty string on failure. You *might want to* implement a flag or separate function that errors out on failure.

Only the first `=` *is to be* interpreted as the key-value split. Spaces *are* explicitly allowed in both the key and the value.

Similarly, only the first appearance of the requested key *is to be* parsed.

You *may* implement convenience functions for parsing values as types other than strings, but be aware that such behaviour is explicitly outside of .mcf's scope.
