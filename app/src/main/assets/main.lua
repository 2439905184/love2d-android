require"Zenitha"

local gc=love.graphics
local kb=love.keyboard

kb.setKeyRepeat(false)

Zenitha.setFirstScene("menu")

do--开始菜单
    local scene={}
    function scene.keyDown(k)
        SCN.go('game','flash')--切换场景到。。。以某种方式。。。
    end
    function scene.draw()
        FONT.set(60)
        GC.mStr("Cube Catching",400,200)
        FONT.set(20)
        GC.mStr("By MrZ",400,280)
        FONT.set(30)
        GC.mStr("Press any key to start",400,420)
    end
    SCN.add("menu",scene)
end

do--游戏场景
    local x,y,vx,vy
    local targets
    local score=0
    local timer

    local function restart()
        timer=0
        score=0
        x,y,vx,vy=0,0,0,0
        targets={}
        for i=1,5 do
            targets[i]={
                x=math.random(-280,280),
                y=math.random(-280,280),
            }
        end
    end

    local scene={}
    function scene.enter()
        restart()
    end
    function scene.keyDown()
    end
    function scene.update(dt)
        -- 方向键控制速度
        if kb.isDown('left')  then vx=vx-.626 end
        if kb.isDown('right') then vx=vx+.626 end
        if kb.isDown('up')    then vy=vy-.626 end
        if kb.isDown('down')  then vy=vy+.626 end

        -- 玩家移动
        x=x+vx
        y=y+vy

        -- 撞墙检测
        if x<-280 then
            x=-280
            vx=-vx*1.5
        elseif x>280 then
            x=280
            vx=-vx*1.5
        end
        if y<-280 then
            y=-280
            vy=-vy*1.5
        elseif y>280 then
            y=280
            vy=-vy*1.5
        end

        -- 移动阻力
        vx=vx*.96
        vy=vy*.96

        -- 检测吃目标
        for i=#targets-3,1,-1 do
            if math.abs(x-targets[i].x)<20 and math.abs(y-targets[i].y)<20 then
                table.remove(targets,i)
                table.insert(targets,{
                    x=math.random(-280,280),
                    y=math.random(-280,280)
                })
                score=score+1
                timer=math.max(timer-8/(score+3)-.5,0)
            end
        end

        -- 秒表走数
        timer=timer+dt
        if timer>=10 then
            SCN.go('menu','flash')
        end
    end
    function scene.draw()
        gc.translate(400,300)

        -- 边框
        gc.setLineWidth(4)
        gc.setColor(.6,.6,.6)
        gc.rectangle('line',-293,-293,586,586)

        -- 秒表
        gc.setColor(1,timer/20*(math.sin(timer*36)+1)/2,0,.1+(timer/10)^2/3)
        gc.rectangle('fill',-293,293,586,-586*timer/10)

        -- 分数
        FONT.set(120)
        gc.setColor(1,1,1,.26)
        GC.mStr(score,0,-72)

        -- 有效目标
        gc.setColor(1,1,0)
        for i=1,#targets-3 do
            gc.rectangle('fill',targets[i].x-10,targets[i].y-10,20,20)
        end

        -- 影子目标
        gc.setLineWidth(2)
        for i=#targets-2,#targets do
            gc.setColor(1,1,0,(#targets-i)/3+.2)
            gc.rectangle('line',targets[i].x-10,targets[i].y-10,20,20)
        end

        -- 玩家
        gc.setColor(1,1,1)
        gc.rectangle('fill',x-10,y-10,20,20)
    end
    SCN.add("game",scene)
end