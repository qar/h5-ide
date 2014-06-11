
define [
  "./StackView"
  "OpsModel"
  "./template/TplOpsEditor"
], ( StackView, OpsModel, OpsEditorTpl )->

  StackView.extend {
    bindUserEvent : ()->
      # Events
      if @workspace.isAppEditMode()
        $("#OEPanelCenter")
          .removeClass('canvas_state_app').addClass("canvas_state_appedit")
          .off(".CANVAS_EVENT")
          .on('mousedown.CANVAS_EVENT', '.instance-volume, .instanceList-item-volume, .asgList-item-volume', MC.canvas.volume.show)
          .on('mousedown.CANVAS_EVENT', '.port', MC.canvas.event.appDrawConnection)
          .on('mousedown.CANVAS_EVENT', '.dragable', MC.canvas.event.dragable.mousedown)
          .on('mousedown.CANVAS_EVENT', '.group-resizer', MC.canvas.event.groupResize.mousedown)
          .on('click.CANVAS_EVENT', '.line', MC.canvas.event.selectLine)
          .on('mousedown.CANVAS_EVENT', MC.canvas.event.clearSelected)
          .on('mousedown.CANVAS_EVENT', '#svg_canvas', MC.canvas.event.clickBlank)
          .on('mouseenter.CANVAS_EVENT mouseleave.CANVAS_EVENT', '.node', MC.canvas.event.nodeHover)
          .on('selectstart.CANVAS_EVENT', false)
          .on('mousedown.CANVAS_EVENT', MC.canvas.event.ctrlMove.mousedown)
          .on('mousedown.CANVAS_EVENT', '#node-action-wrap', MC.canvas.nodeAction.popup)
      else
        $("#OEPanelCenter")
          .removeClass('canvas_state_appedit').addClass("canvas_state_app")
          .off(".CANVAS_EVENT")
          .on('mousedown.CANVAS_EVENT', '.instance-volume, .instanceList-item-volume, .asgList-item-volume', MC.canvas.volume.show)
          .on('click.CANVAS_EVENT', '.line', MC.canvas.event.selectLine)
          .on('mousedown.CANVAS_EVENT', MC.canvas.event.clearSelected)
          .on('mousedown.CANVAS_EVENT', '#svg_canvas', MC.canvas.event.clickBlank)
          .on('selectstart.CANVAS_EVENT', false)
          .on('mousedown.CANVAS_EVENT', '.dragable', MC.canvas.event.selectNode)
          .on('mousedown.CANVAS_EVENT', '.AWS-AutoScaling-LaunchConfiguration .instance-number-group', MC.canvas.asgList.show)
          .on('mousedown.CANVAS_EVENT', '.AWS-EC2-Instance .instance-number-group', MC.canvas.instanceList.show)
          .on('mousedown.CANVAS_EVENT', '.AWS-VPC-NetworkInterface .eni-number-group', MC.canvas.eniList.show)
          .on('mousedown.CANVAS_EVENT', MC.canvas.event.ctrlMove.mousedown)
          .on('mousedown.CANVAS_EVENT', '#node-action-wrap', MC.canvas.nodeAction.popup)
          .on('mouseenter.CANVAS_EVENT mouseleave.CANVAS_EVENT', '.node', MC.canvas.event.nodeHover)
      return

    renderSubviews : ()->
      if @workspace.isAppEditMode()
        @resourcePanel.render()

      $("#OEPanelLeft").toggleClass "force-hidden", !@workspace.isAppEditMode()

      @statusbar.render()
      return

    toggleProcessing : ()->
      @toolbar.updateTbBtns()
      @$el.children(".ops-process").remove()

      opsModel = @workspace.opsModel
      if opsModel.isProcessing()
        @$el.append OpsEditorTpl.loading({ content : text })
      return

    switchMode : ( isAppEditMode )->
      @toolbar.updateTbBtns()
      $("#OEPanelLeft").toggleClass "force-hidden", !isAppEditMode
      @resourcePanel.render()
      @propertyPanel.refresh()
      @bindUserEvent()
      return
  }
