use std::hash::{Hash, Hasher};

impl<T> Copy for LayoutDom<'_, T> {}

pub struct LayoutDom<'dom, T> {
    pub value: &'dom T,
}

impl<T> Clone for LayoutDom<'_, T> {
    #[inline]
    #[allow(clippy::non_canonical_clone_impl)]
    fn clone(&self) -> Self {
        *self
    }
}

impl<T> Hash for LayoutDom<'_, T> {
    fn hash<H: Hasher>(&self, state: &mut H) {
        (self.value as *const T).hash(state)
    }
}

impl<T> PartialEq for LayoutDom<'_, T> {
    fn eq(&self, other: &Self) -> bool {
        std::ptr::eq(self.value, other.value)
    }
}

impl<T> Eq for LayoutDom<'_, T> {}

// impl<'dom, T> LayoutDom<'dom, T>
// where
//     T: Castable,
// {
//     /// Cast a DOM object root upwards to one of the interfaces it derives from.
//     pub fn upcast<U>(&self) -> LayoutDom<'dom, U>
//     where
//         U: Castable,
//         T: DerivedFrom<U>,
//     {
//         LayoutDom {
//             value: self.value.upcast::<U>(),
//         }
//     }

//     /// Cast a DOM object downwards to one of the interfaces it might implement.
//     pub fn downcast<U>(&self) -> Option<LayoutDom<'dom, U>>
//     where
//         U: DerivedFrom<T>,
//     {
//         self.value.downcast::<U>().map(|value| LayoutDom { value })
//     }

//     /// Returns whether this inner object is a U.
//     pub fn is<U>(&self) -> bool
//     where
//         U: DerivedFrom<T>,
//     {
//         self.value.is::<U>()
//     }
// }

//  pub trait Castable: Sized {
//     /// Check whether a DOM object implements one of its deriving interfaces.
//     fn is<T>(&self) -> bool
//     where
//         T: DerivedFrom<Self>,
//     {
//         let class = unsafe { get_dom_class(self.reflector().get_jsobject().get()).unwrap() };
//         T::derives(class)
//     }

//     /// Cast a DOM object upwards to one of the interfaces it derives from.
//     fn upcast<T>(&self) -> &T
//     where
//         T: Castable,
//         Self: DerivedFrom<T>,
//     {
//         unsafe { mem::transmute::<&Self, &T>(self) }
//     }

//     /// Cast a DOM object downwards to one of the interfaces it might implement.
//     fn downcast<T>(&self) -> Option<&T>
//     where
//         T: DerivedFrom<Self>,
//     {
//         if self.is::<T>() {
//             Some(unsafe { mem::transmute::<&Self, &T>(self) })
//         } else {
//             None
//         }
//     }
// }

// pub trait DerivedFrom<T: Castable>: Castable {}
