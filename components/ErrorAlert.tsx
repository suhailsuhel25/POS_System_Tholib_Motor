'use client';

import {
    AlertDialog,
    AlertDialogAction,
    AlertDialogContent,
    AlertDialogDescription,
    AlertDialogFooter,
    AlertDialogHeader,
    AlertDialogTitle,
} from "@/components/ui/alert-dialog";
import { AlertTriangle } from "lucide-react";

interface ErrorAlertProps {
    open: boolean;
    onClose: () => void;
    title?: string;
    message: string;
}

export function ErrorAlert({ open, onClose, title = "Error", message }: ErrorAlertProps) {
    return (
        <AlertDialog open={open} onOpenChange={onClose}>
            <AlertDialogContent className="border-[#DFE1E6] dark:border-[#2C333A] bg-white dark:bg-[#22272B]">
                <AlertDialogHeader>
                    <div className="flex items-center gap-3">
                        <div className="w-12 h-12 rounded-full bg-[#FFEBE6] dark:bg-[#4A1A1A] flex items-center justify-center">
                            <AlertTriangle className="w-6 h-6 text-[#DE350B]" />
                        </div>
                        <div className="flex-1">
                            <AlertDialogTitle className="text-lg font-bold text-[#172B4D] dark:text-white">
                                {title}
                            </AlertDialogTitle>
                        </div>
                    </div>
                    <AlertDialogDescription className="text-base text-[#626F86] dark:text-[#8C9BAB] mt-3">
                        {message}
                    </AlertDialogDescription>
                </AlertDialogHeader>
                <AlertDialogFooter>
                    <AlertDialogAction
                        onClick={onClose}
                        className="bg-[#0052CC] hover:bg-[#0747A6] text-white font-medium h-10"
                    >
                        Mengerti
                    </AlertDialogAction>
                </AlertDialogFooter>
            </AlertDialogContent>
        </AlertDialog>
    );
}
