# Deprecations and removals in Ruby itself

Bullets mentioning deprecation/removal/obsoletion, extracted from the official
NEWS file of each Ruby minor release (ruby/ruby repository).

## Ruby 2.0 (11 entries)

- deprecated methods:
- IO#lines, #bytes, #chars and #codepoints are deprecated.
- Mutex#lock, Mutex#unlock, Mutex#try_lock, Mutex#synchronize and Mutex#sleep are no longer allowed to be used from trap handler and raise a ThreadError in such case.
- removed Proc#== and #eql? so two procs are == only when they are the same object.
- Removed CSV::dump and CSV::load to protect users from dangerous serialization vulnerability
- Iconv has been removed. Use String#encode instead.
- deprecated methods:
- StringIO#lines, #bytes, #chars and #codepoints are deprecated.
- Syck has been removed. YAML now completely depends on libyaml being installed.
- deprecated methods:
- Zlib::GzipReader#lines and #bytes are deprecated.

## Ruby 2.1 (10 entries)

- obsoleted environment variables:
- Module#refine is no longer experimental.
- Mutex#owned? is no longer experimental.
- main.using is no longer experimental. The method activates refinements in the ancestors of the argument module to support refinement inheritance by Module#include.
- Hash#reject will return plain Hash object in the future versions, that is the original object's subclass, instance variables, default value, and taintedness will be no longer copied, so now warnings are emitted when called with such Hash.
- These methods are deprecated and their behavior is the same as tainted?, taint, and untaint, respectively. If $VERBOSE is true, they show warnings.
- The exception to terminate the given block can no longer be rescued inside the block, by default, unless the exception class is given explicitly.
- Removed. curses is now available as a gem. See https://rubygems.org/gems/curses for details.
- $SAFE=4 is obsolete. If $SAFE is set to 4 or larger, an ArgumentError is raised.
- rb_gc_set_params() is deprecated. This is only used in Ruby internal.

## Ruby 2.2 (16 entries)

- Enumerable#slice_before's state management deprecated.
- Enumerable#chunk's state management deprecated.
- ArgumentError is no longer raised when lambda Proc is passed as a block, and the number of yielded arguments does not match the formal arguments of the lambda, if just an array is yielded and its length matches.
- callcc is obsolete. use Fiber instead.
- Digest::HMAC has been removed just as previously noticed.
- DL has been removed from stdlib. Please use Fiddle instead!
- Show deprecated warning [Feature #10169]
- Removed because it's empty file.
- Removed because it is deprecated from 2009.
- Removed because it is deprecated from 2009.
- Removed PrettyPrint#first?
- Removed because it conflicts to minitest 5. [Feature #9711]
- Removed because it conflicts to minitest 5, and it was just an wrapper of minitest 4. [Feature #9711]
- Removed Psych::EngineManager [Bug #8344]
- Deprecated APIs removed. [Feature #9502]
- st hash table uses power-of-two sizes for speed [Feature #9425]. Lookups are 10-25% faster if using appropriate hash functions. However, weaknesses in hash distribution can no longer be masked by prime number-sized tables, so extensions may need to tweak hash functions to ensure good distribution.

## Ruby 2.3 (19 entries)

- Comparable#== no longer rescues exceptions [Feature #7688]
- IO#advise no longer raises Errno::ENOSYS in cases where it was detected at build time but not available at runtime. [Feature #11806]
- Module#deprecate_constant [Feature #11398]
- Array#select!, Array#keep_if, Array#reject!, and Array#delete_if no longer changes the receiver array instantly every time the block is called. [Feature #10714]
- Array#flatten and Array#flatten! no longer try to call #to_ary method on elements beyond the given level. [Bug #10748]
- Enumerable#chunk and Enumerable#slice_before no longer takes the initial_state argument. [Feature #10958] Use a local variable instead to maintain a state.
- IO#wait_readable no longer checks FIONREAD, it may be used for non-bytestream IO such as listen sockets.
- In read-only mode, StringIO#set_encoding no longer sets the encoding of its buffer string. Setting the encoding of the string directly without StringIO#set_encoding may cause unpredictable behavior now. [Bug #11827]
- Object#timeout is now warned as deprecated when called.
- removed unused argument. https://github.com/ruby/ruby/pull/515
- removed unused argument. https://github.com/ruby/ruby/pull/356
- Rake is removed from stdlib. [Feature #11025]
- $SAFE=2 and $SAFE=3 are obsolete. If $SAFE is set to 2 or larger, an ArgumentError is raised. [Feature #5455]
- rb_autoload() deprecated, use rb_funcall() instead. [Feature #11664]
- rb_compile_error_with_enc(), rb_compile_error(), and rb_compile_bug() deprecated. these functions are exposed but only for internal use. external libraries should not use them.
- OS/2 is no longer supported
- BeOS is no longer supported
- Borland-C is no longer supported
- (Linux-only) waiting on a single FD anywhere in the stdlib no longer uses select(2), making it immune to slowdowns with high-numbered FDs. [Feature #11081] [Feature #11377]

## Ruby 2.4 (9 entries)

- RubyVM::Env was removed.
- String#upcase, String#downcase, String#capitalize, String#swapcase and their bang variants work for all of Unicode, and are no longer limited to ASCII. Supported encodings are UTF-8, UTF-16BE/LE, UTF-32BE/LE, and ISO-8859-1~16. Variations are available with options. See the documentation of String#downcase for details. [Feature #10085]
- IPAddr#== and IPAddr#<=> no longer raise an exception if coercion fails. [Bug #12799]
- the extension library is removed. Till 2.0 it was a pure ruby script "thread.rb", which has precedence over "thread.so", and has been provided in $LOADED_FEATURES since 2.1.
- Tk is removed from stdlib. [Feature #8539]
- XMLRPC is removed from stdlib, and bundled as gem. [Feature #12160][ruby-core:74239]
- ruby_show_version() will no longer exits the process, if RUBY_SHOW_COPYRIGHT_TO_DIE is set to 0. This will be the default in the future.
- FreeBSD < 4 is no longer supported
- ChangeLog is removed from the repository.

## Ruby 2.5 (17 entries)

- Top-level constant look-up is removed. [Feature #11547]
- Is deprecated. It was a base class for C extensions, and it's not necessary to expose in Ruby level. [Feature #3072]
- Numeric#step no longer hides errors from coerce method when given a step value which cannot be compared with #> to 0. [Feature #7688]
- Numerical comparison operators (<,<=,>=,>) no longer hide exceptions from #coerce method internally. Return nil in #coerce if the coercion is impossible. [Feature #7688]
- Range#initialize no longer hides exceptions when comparing begin and end with #<=> and raise a "bad value for range" ArgumentError but instead lets the exception from the #<=> call go through. [Feature #7688]
- The following features have been deprecated, and are planned to be removed in the version 1.4.0:
- ACL::ACLEntry.new no longer suppresses IPAddr::InvalidPrefixError.
- Carriage returns are changed to be trimmed properly if trim_mode is specified and used. Duplicated newlines will be removed on Windows. [Bug #5339] [Bug #11464]
- IPAddr no longer accepts invalid address mask. [Bug #13399]
- IPAddr#ipv4_compat and IPAddr#ipv4_compat? are marked for deprecation. [Bug #13769]
- URI.open method defined as an alias to open-uri's Kernel.open. open-uri's Kernel.open will be deprecated in future.
- Remove deprecated method aliases for syck gem https://github.com/ruby/psych/pull/312
- Relative path operations no longer collapse consecutive slashes to a single slash. [Bug #8352]
- BasicSocket#read_nonblock and BasicSocket#write_nonblock no longer set the O_NONBLOCK file description flag as side effect (on Linux only) [Feature #13362]
- ConditionVariable, Queue and SizedQueue reimplemented for speed. They no longer subclass Struct. [Feature #13552]
- Removed from stdlib. [Feature #10169]
- Removed "ubygems.rb" file from stdlib. It's needless since Ruby 1.9.

## Ruby 2.6 (13 entries)

- The "shadowing outer local variable" warning is removed. [Feature #12490]
- The flip-flop syntax is deprecated. [Feature #5400]
- String#crypt is now deprecated. [Feature #14915]
- 1.3.5 has BigDecimal.new without "exception:" keyword. You can see the deprecation warning of BigDecimal.new when you specify "-w" option. BigDecimal(), BigDecimal.new, and Object#to_d methods are the same.
- 1.4.0 has BigDecimal.new with "exception:" keyword. You always see the deprecation warning of BigDecimal.new. Object#to_d method is different from BigDecimal() and BigDecimal.new.
- Add +:trim_mode+ and +:eoutvar+ keyword arguments to ERB.new. Now non-keyword arguments other than the first one are softly deprecated and will be removed when Ruby 2.5 becomes EOL. [Feature #14256]
- erb command's <tt>-S</tt> option is deprecated, and will be removed in the next version.
- Add Net::HTTPClientException to deprecate Net::HTTPServerException, whose name is misleading. [Bug #14688]
- Dir.glob with <code>'\0'</code>-separated pattern list will be deprecated, and is now warned. [Feature #14643]
- Object#=~ is deprecated. [Feature #15231]
- The following methods are removed.
- BigDecimal.new will be removed in version 2.0.
- On macOS, shared libraries no longer include a full version number of Ruby in their names. This eliminates the burden of each teeny upgrade on the platform that users need to rebuild every extension library.

## Ruby 2.7 (15 entries)

- Note that the slides are slightly obsolete.
- Automatic conversion of keyword arguments and positional arguments is deprecated, and conversion will be removed in Ruby 3. [Feature #14183]
- Passing an empty keyword splat to a method that does not accept keywords no longer passes an empty hash, unless the empty hash is necessary for a required parameter, in which case a warning will be emitted. Remove the double splat to continue passing a positional hash. [Feature #14183]
- Above warnings can be suppressed also with {-W:no-deprecated option}[#label-Warning+option].
- Setting <code>$;</code> to a non-nil value will now display a warning. [Feature #14240] This includes the usage in String#split. This warning can be suppressed with {-W:no-deprecated option}[#label-Warning+option].
- Setting <code>$,</code> to a non-nil value will now display a warning. [Feature #14240] This includes the usage in Array#join. This warning can be suppressed with {-W:no-deprecated option}[#label-Warning+option].
- The flip-flop syntax deprecation is reverted. [Feature #5400]
- +yield+ in singleton class syntax will now display a warning. This behavior will soon be deprecated. [Feature #15575].
- <code>Object#{taint,untaint,trust,untrust}</code> and related functions in the C-API no longer have an effect (all objects are always considered untainted), and will now display a warning in verbose mode. This warning will be disabled even in non-verbose mode in Ruby 3.0, and the methods and C functions will be removed in Ruby 3.2. [Feature #16131]
- To suppress deprecation warnings:
- Dir.glob and Dir.[] no longer allow NUL-separated glob pattern. Use Array instead. [Feature #14643]
- The following libraries are no longer bundled gems. Install corresponding gems to use these features.
- Removed from standard library. It was unmaintained since Ruby 2.0.0.
- The <code>:</code> character in rb_scan_args format string is now treated as keyword arguments. Passing a positional hash instead of keyword arguments will emit a deprecation warning.
- Support for IA64 architecture has been removed. Hardware for testing was difficult to find, native fiber code is difficult to implement, and it added non-trivial complexity to the interpreter. [Feature #15894]

## Ruby 3.0 (20 entries)

- Keyword arguments are now separated from positional arguments. Code that resulted in deprecation warnings in Ruby 2.7 will now result in ArgumentError or different behavior. [[Feature #14183]]
- Procs accepting a single rest argument and keywords are no longer subject to autosplatting. This now matches the behavior of Procs accepting a single rest argument and no keywords. [[Feature #16166]]
- Pattern matching (`case/in`) is no longer experimental. [[Feature #17260]]
- Interpolated String literals are no longer frozen when `# frozen-string-literal: true` is used. [[Feature #17104]]
- Deprecation warnings are no longer shown by default (since Ruby 2.7.2). Turn them on with `-W:deprecated` (or with `-w` to show other warnings too). [[Feature #16345]]
- `$SAFE` and `$KCODE` are now normal global variables with no special behavior. C-API methods related to `$SAFE` have been removed. [[Feature #16131]] [[Feature #17136]]
- `Random::DEFAULT` is deprecated since its value is now confusing and it is no longer global, use `Kernel.rand`/`Random.rand` directly, or create a `Random` instance with `Random.new` instead. [[Feature #17351]]
- SortedSet has been removed for dependency and performance reasons.
- Initialization is no longer lazy. [[Bug #12136]]
- URI.escape and URI.unescape have been removed. Instead, use the following methods depending on your specific use case.
- `TRUE`/`FALSE`/`NIL` constants are no longer defined.
- Enumerable#grep and Enumerable#grep_v when passed a Regexp and no block no longer modify Regexp.last_match. [[Bug #17030]]
- Requiring 'open-uri' no longer redefines `Kernel#open`. Call `URI.open` directly or `use URI#open` instead. [[Misc #15893]]
- SortedSet has been removed for dependency and performance reasons.
- net-telnet and xmlrpc have been removed from the bundled gems. If you are interested in maintaining them, please comment on your plan to https://github.com/ruby/xmlrpc or https://github.com/ruby/net-telnet.
- SDBM has been removed from the Ruby standard library. [[Bug #8446]]
- WEBrick has been removed from the Ruby standard library. [[Feature #17303]]
- C API functions related to `$SAFE` have been removed. [[Feature #16131]]
- Methods using `ruby2_keywords` will no longer keep empty keyword splats, those are now removed just as they are for methods not using `ruby2_keywords`.
- Accessing an uninitialized instance variable no longer emits a warning in verbose mode. [[Feature #17055]]

## Ruby 3.1 (7 entries)

- One-line pattern matching is no longer experimental.
- New class which represents a module created by Module#refine. `include` and `prepend` are deprecated, and `import_methods` is added instead. [[Bug #17429]]
- The following gems has been removed from the Ruby standard library.
- `rb_io_wait_readable`, `rb_io_wait_writable` and `rb_wait_for_single_fd` are deprecated in favour of `rb_io_maybe_wait_readable`, `rb_io_maybe_wait_writable` and `rb_io_maybe_wait` respectively. `rb_thread_wait_fd` and `rb_thread_fd_writable` are deprecated. [[Bug #18003]]
- `rb_gc_force_recycle` is deprecated and has been changed to a no-op. [[Feature #18290]]
- JIT-ed code is no longer cancelled when a TracePoint for class events is enabled.
- The JIT compiler no longer skips compilation of methods longer than 1000 instructions.

## Ruby 3.2 (12 entries)

- A proc that accepts a single positional argument and keywords will no longer autosplat. [[Bug #18633]]
- "Find pattern" is no longer experimental. [[Feature #18585]]
- Encoding#replicate has been deprecated and will be removed in 3.3. [[Feature #18949]]
- The dummy `Encoding::UTF_16` and `Encoding::UTF_32` encodings no longer try to dynamically guess the endian based on a byte order mark. Use `Encoding::UTF_16BE`/`UTF_16LE` and `Encoding::UTF_32BE`/`UTF_32LE` instead. This change speeds up getting the encoding of a String. [[Feature #18949]]
- It no longer allocates a String object when no character needs to be escaped.
- `-S` option is removed from `erb` command.
- Ruby no longer escapes control characters and backslashes in an error message. [[Feature #18367]]
- Psych no longer bundles libyaml sources. And also Fiddle no longer bundles libffi sources. Users need to install the libyaml/libffi library themselves via the package manager like apt, yum, brew, etc.
- Cache invalidation for expressions referencing constants is now more fine-grained. `RubyVM.stat(:global_constant_state)` was removed because it was closely tied to the previous caching scheme where setting any constant invalidates all caches in the system. New keys, `:constant_cache_invalidations` and `:constant_cache_misses`, were introduced to help with use cases for `:global_constant_state`. [[Feature #18589]]
- YJIT is no longer experimental
- As a result, Microsoft Visual Studio (MSWIN) is no longer supported.
- MinGW is no longer supported. [[Feature #18824]]

## Ruby 3.3 (19 entries)

- `Encoding#replicate` has been removed, it was already deprecated. [[Feature #18949]]
- Process::Status#& and Process::Status#>> are deprecated. [[Bug #19868]]
- Add Refinement#target as an alternative of Refinement#refined_class. Refinement#refined_class is deprecated and will be removed in Ruby 3.4. [[Feature #19714]]
- Subprocess creation/forking via the following file open methods is deprecated. [[Feature #19630]]
- When given a non-lambda, non-literal block, Kernel#lambda with now raises ArgumentError instead of returning it unmodified. These usages have been issuing warnings under the `Warning[:deprecated]` category since Ruby 3.0.0. [[Feature #19777]]
- The `RUBY_GC_HEAP_INIT_SLOTS` environment variable has been deprecated and removed. Environment variables `RUBY_GC_HEAP_%d_INIT_SLOTS` should be used instead. [[Feature #19785]]
- `it` calls without arguments in a block with no ordinary parameters are deprecated. `it` will be a reference to the first block parameter in Ruby 3.4. [[Feature #18980]]
- We no longer need to install libraries like `libreadline` or `libedit`.
- New APIs and deprecated APIs (see comments for details)
- deprecated: `rb_postponed_job_register()` (and semantic change. see below)
- deprecated: `rb_postponed_job_register_one()`
- The postponed job APIs have been changed to address some rare crashes. To solve the issue, we introduced new two APIs and deprecated current APIs. The semantics of these functions have also changed slightly; `rb_postponed_job_register` now behaves like the `once` variant in that multiple calls with the same `func` might be coalesced into a single execution of the `func` [[Feature #20057]]
- The details of `rb_io_t` will be hidden and deprecated attributes are added for each members. [[Feature #19057]]
- Replace Bison with [Lrama LALR parser generator](https://github.com/ruby/lrama). No need to install Bison to build Ruby from source code anymore. We will no longer suffer bison compatibility issues and we can use new features by just implementing it to Lrama. [[Feature #19637]]
- Young objects referenced by old objects are no longer immediately promoted to the old generation. This significantly reduces the frequency of major GC collections. [[Feature #19678]]
- Unsupported call types and megamorphic call sites no longer exit to the interpreter.
- `ratio_in_yjit` stat produced by `--yjit-stats` is now available in release builds, a special stats or dev build is no longer required to access most stats.
- MJIT is removed.
- `--disable-jit-support` is removed. Consider using `--disable-yjit --disable-rjit` instead.

## Ruby 3.4 (12 entries)

- String literals in files without a `frozen_string_literal` comment now emit a deprecation warning when they are mutated. These warnings can be enabled with `-W:deprecated` or by setting `Warning[:deprecated] = true`. To disable this change, you can run Ruby with the `--disable-frozen-string-literal` command line argument. [[Feature #20205]]
- `String#+@` now duplicates when mutating the string would emit a deprecation warning, offered as a replacement for the `str.dup if str.frozen?` pattern.
- Block passing is no longer allowed in index assignment (e.g. `a[0, &b] = 1`). [[Bug #19918]]
- Keyword arguments are no longer allowed in index assignment (e.g. `a[0, kw: 1] = 2`). [[Bug #20218]]
- The toplevel name `::Ruby` is reserved now, and the definition will be warned when `Warning[:deprecated]`. [[Feature #20884]]
- The string returned by `Symbol#to_s` now emits a deprecation warning when mutated, and will be frozen in a future version of Ruby. These warnings can be enabled with `-W:deprecated` or by setting `Warning[:deprecated] = true`. [[Feature #20350]]
- Extra `rescue`/`ensure` frames are no longer available on the backtrace. [[Feature #20275]]
- `Refinement#refined_class` has been removed. [[Feature #19714]]
- `DidYouMean::SPELL_CHECKERS[]=` and `DidYouMean::SPELL_CHECKERS.merge!` are removed.
- Removed the following deprecated constants:
- `rb_newobj` and `rb_newobj_of` (and corresponding macros `RB_NEWOBJ`, `RB_NEWOBJ_OF`, `NEWOBJ`, `NEWOBJ_OF`) have been removed. [[Feature #20265]]
- Removed deprecated function `rb_gc_force_recycle`. [[Feature #18290]]

## Ruby 4.0 (17 entries)

- `*nil` no longer calls `nil.to_a`, similar to how `**nil` does not call `nil.to_hash`. [[Feature #21047]]
- `Binding#local_variables` does no longer include numbered parameters. Also, `Binding#local_variable_get`, `Binding#local_variable_set`, and `Binding#local_variable_defined?` reject to handle numbered parameters. [[Bug #21049]]
- A deprecated behavior, process creation by `IO` class methods with a leading `|`, was removed. [[Feature #19630]]
- A deprecated behavior, process creation by `Kernel#open` with a leading `|`, was removed. [[Feature #19630]]
- `Ractor#close_incoming` and `Ractor#close_outgoing` were removed.
- Passing arguments to `Set#to_set` and `Enumerable#to_set` is now deprecated. [[Feature #21390]]
- The following methods were removed from Ractor due to the addition of `Ractor::Port`:
- `ObjectSpace._id2ref` is deprecated. [[Feature #15408]]
- `Process::Status#&` and `Process::Status#>>` have been removed. They were deprecated in Ruby 3.3. [[Bug #19868]]
- `rb_path_check` has been removed. This function was used for `$SAFE` path checking which was removed in Ruby 2.7, and was already deprecated. [[Feature #20971]]
- Backtraces no longer display `internal` frames. These methods now appear as if it is in the Ruby source file, consistent with other C-implemented methods. [[Bug #20968]]
- CGI library is removed from the default gems. Now we only provide `cgi/escape` for the following methods:
- With the move of `Set` from stdlib to core class, `set/sorted_set.rb` has been removed, and `SortedSet` is no longer an autoloaded constant. Please install the `sorted_set` gem and `require 'sorted_set'` to use `SortedSet`. [[Feature #21287]]
- The default behavior of automatically setting the `Content-Type` header to `application/x-www-form-urlencoded` for requests with a body (e.g., `POST`, `PUT`) when the header was not explicitly set has been removed. If your application relied on this automatic default, your requests will now be sent without a Content-Type header, potentially breaking compatibility with certain servers. [[GH-net-http #205]]
- `rb_thread_fd_close` is deprecated and now a no-op. If you need to expose file descriptors from C extensions to Ruby code, create an `IO` instance using `RUBY_IO_MODE_EXTERNAL` and use `rb_io_close(io)` to close it (this also interrupts and waits for all pending operations on the `IO` instance). Directly closing file descriptors does not interrupt pending operations, and may lead to undefined behaviour. In other words, if two `IO` objects share the same file descriptor, closing one does not affect the other. [[Feature #18455]]
- `ratio_in_yjit` no longer works in the default build. Use `--enable-yjit=stats` on `configure` to enable it on `--yjit-stats`.
- `--rjit` is removed. We will move the implementation of the third-party JIT API to the [ruby/rjit](https://github.com/ruby/rjit) repository.

## Ruby head (3 entries)

- `Module#clone` and `Module#dup` no longer rewrite the lexical scope of copied methods. Constants and class variables resolve through the original class, consistent with inheritance and mixins. [[Feature #21981]]
- `ObjectSpace._id2ref` was removed. [[Feature #22135]]
- A deprecated behavior, `Set#to_set`, `Range#to_set`, and `Enumerable#to_set` accepting arguments, was removed. [[Feature #21390]]
