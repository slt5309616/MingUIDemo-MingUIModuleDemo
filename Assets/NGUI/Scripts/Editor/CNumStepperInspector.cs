using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Assets.Scripts.Com.MingUI;
using UnityEditor;

namespace Assets.NGUI.Scripts.Editor{
    [CustomEditor(typeof (CNumStepper))] ///
    /// 
    internal class CNumStepperInspector : UIWidgetInspector{
        protected override void DrawCustomProperties(){
            NGUIEditorTools.DrawProperty("Input", serializedObject, "Input");
            NGUIEditorTools.DrawProperty("UpBtn", serializedObject, "UpBtn");
            NGUIEditorTools.DrawProperty("DownBtn", serializedObject, "DownBtn");
            NGUIEditorTools.DrawProperty("MaxBtn", serializedObject, "btnMax");
            NGUIEditorTools.DrawProperty("MinBtn", serializedObject, "btnMin");
            NGUIEditorTools.DrawProperty("Min", serializedObject, "Min");
            NGUIEditorTools.DrawProperty("Max", serializedObject, "Max");
            NGUIEditorTools.DrawProperty("Step", serializedObject, "Step");
            NGUIEditorTools.DrawProperty("DefaultValue", serializedObject, "DefaultValue");
            
            base.DrawCustomProperties();
        }
    }
}