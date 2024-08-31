syscall::open:entry
/pid == $1 /
{
  printf("%s(%s)", probefunc, copyinstr(arg0));
}
syscall::open:return
/pid == $1 /
{
  printf("\t\t = %d\n", arg1);
}
syscall::close:entry
/pid == $1/
{
  printf("%s(%d)\n", probefunc, arg0);
}