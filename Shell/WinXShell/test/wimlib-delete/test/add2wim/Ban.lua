f = io.open("tmp\\2List.txt","r"):read("*a")
u = f:gsub("([^%c]+)", 'delete --force --recursive "%1"')
io.open("tmp\\excel.txt","w+"):write(u)

