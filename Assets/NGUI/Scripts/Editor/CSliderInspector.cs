using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Assets.Scripts.Com.MingUI;
using UnityEditor;

namespace Assets.NGUI.Scripts.Editor{
    [CustomEditor(typeof (CSlider))] ///
    internal class CSliderInspector : UISpriteInspector{
        protected override void DrawCustomProperties(){
            NGUIEditorTools.DrawProperty("Thumb", serializedObject, "Thumb");
            NGUIEditorTools.DrawProperty("PaddingLeft", serializedObject, "PaddingLeft");
            NGUIEditorTools.DrawProperty("PaddingRight", serializedObject, "PaddingRight");
            base.DrawCustomProperties();
        }
    }
}