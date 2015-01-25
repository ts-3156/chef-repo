Memo
====

Initialize knife.

```
be knife configure
```

Initialize berkshelf.

```
be berks vendor cookbooks
```

Create a cookbook.

```
be knife cookbook create dev_tools -o site-cookbooks/
```

Install chef client on specified host.

```
be knife solo prepare -i xxx.pem  USER@HOST
```

Run chef on specified host.

```
be knife solo cook -i xxx.pem USER@HOST
```

Run test.

```
user=USER host=HOST key=xxx.pem bundle exec rake
```
