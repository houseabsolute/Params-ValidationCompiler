## Parameter specs

### Type

* No type, just required
* Has a type -> [Types](#types)

### Required or not

* Required
* Optional

### Defaults

* No default
* Has a non-sub defualt
* Has a subroutine default

### Slurpy

* Any type
* A specific type -> [Types](#types)

## Parameter passing style

* Named
* Named to list
* Positional

## Types

### Type System

* Moose
* Specio
* Type::Tiny

### Inlining

* Type can be inlined
  * Type inlining requires "env" vars
  * Coercion inlining requires "env" vars
* Type cannot be inlined

### Coercions

* No coercion
* With coercion(s)
  * that can all be inlined
  * none of which can be inlined
  * some of which can be inlined
