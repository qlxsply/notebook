## Git多账号设置



## 推送本地仓库至GIT

```shell
1.本地创建git仓库
$ git init

2.本地添加文件至仓库中(git add -u:仅更新 git add .：更新+新增 git add -A:更新+新增+删除)
$ git add -A

3.提交至本地仓库
$ git commit -m "注释"

4.关联至远程仓库
$ git remote add origin git@github.com:qlxsply/test.git

5.此时本地仓库和远程仓库依然是两个独立的仓库，使用–allow-unrelated-histories合并仓库
$ git pull origin master --allow-unrelated-histories

6.此时提醒Please enter a commit message to explain why this merge is necessary
添加合并信息，退出编辑，完成合并

7.将本地仓库推送至远程仓库，使用--set-upstream设置默认的仓库+分支
$ git push --set-upstream origin master
```

1.pull
取回远程主机某个分支的更新，再与本地的指定分支合并，pull = fetch + merge

//快进式合并
git pull(fast-forward if possible)
git pull(fast-forward only)

//rebase
git pull(rebase)

//从远程分支获取最新内容，但是不合并。
git fetch 
2.merge和rebase
合并分支，将当前分支移动到其他分支

//两个词的字面意思： into 就是进入;到...里面  onto 移到...上面

使用场景：本地master分支开发，远程master分支有新提交，需要合并远程分支到本地分支继续开发。

原始分支：
 A---B---C  remotes/origin/master
 /
 D---E---F---G  master（本地）


//将另一先提交的的分支合并到自己分支，然后继续开发，两条线
merge 分支1 into 分支2

 A---B---C remotes/origin/master
 /         \
 D---E---F---G---H master（本地）


//rebase到另一先提交的分支上继续开发，一条线
rebase 分支1 onto 分支2

 remotes/origin/master
 |
 D---E---A---B---C---F'---G' master（本地）
3.stash
保存当前进度的代码

//保存当前工作进度，会把暂存区和工作区的改动保存起来。
git stash
//显示保存进度的列表
git stash list
//恢复最新的进度到工作区
git stash pop
//除了不删除恢复的进度之外，其余和git stash pop 命令一样
git stash apply
//删除一个存储的进度。
git stash drop
//删除所有存储的进度。
git stash clear
4.push
将代码提交到远程仓库

//将本地分支内容提交到远程分支
git push
5.cherrypick commit
将其他分支的某个提交合并到当前分支

a--b--c--d--e--f   master
 \ 
 g--h--i--j   test
当前在test分支，现在需要master的e提交的功能，在e 执行cherryPick commit
a--b--c--d--e--f
 \
 g--h--i--j--e<
6.reset commit
将一个分支的末端指向另一个提交。这可以用来移除当前分支的一些提交,这两个提交之后会被删除。

soft  缓存区和工作目录都不会被改变

mixed  默认选项。缓存区和你指定的提交同步，但工作目录不受影响（只将缓存区的移除，工作目录不变）
结果：工作目录不变，需要

Hard 缓存区和工作目录都同步到你指定的提交（二者都移除)
结果：在指定commit处执行reset hard，该处commit之后的所有提交被删除，没有记录
7.revert commit
在指定的某个提交上revert commit，他会做一个新的commit（去掉revert的commit）

如图：在c commit执行revert，结果会在F之后提交一个新的commit，该commit不包含c commit的内容

A---B---C---F remotes/origin/master              A---B---C---F---new（没有c的提交）
       /                      revert commit c -->          / 
     D---E master（本地）                                 D---E 
8.checkout
1.切换分支 2.用于从历史提交（或者 stage 缓存）中拷贝文件到工作目录